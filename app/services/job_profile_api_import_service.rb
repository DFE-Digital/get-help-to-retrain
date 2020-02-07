class JobProfileApiImportService
  attr_reader :api_key
  API_KEY = 'some key'.freeze

  def initialize(
    api_key: API_KEY
  )
    @api_key = api_key
  end

  def job_profiles_list
    uri = URI('https://api.nationalcareers.service.gov.uk/job-profiles/summary')
    request = Net::HTTP::Get.new(uri.request_uri)
    # Request headers
    request['version'] = 'v1'
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = api_key
    # Request body
    request.body = "{body}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end

    JSON.parse(response.body).map do |record|
      url = record["Url"]
      title = record["Title"]
      persist_job_profile(url, title)
    end

    V2JobProfile.all.map do |job_profile|
      update_job_profile(job_profile.source_url)
      sleep 0.5
    end
  end

  def persist_job_profile(url, title)
    slug = url.match(%r{job-profiles/(.*)$})[1]
    V2JobProfile.find_or_create_by(slug: slug) do |job_profile|
      job_profile.update(source_url: url, name: title)
    end
  end

  def update_job_profile(url)
    uri = URI(url)

    request = Net::HTTP::Get.new(uri.request_uri)
    # Request headers
    request['version'] = 'v1'
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = api_key
    # Request body
    request.body = "{body}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    body = JSON.parse(response.body)
    job_profile_api = JobProfileAPI.new(body)
    job_profile = V2JobProfile.find_by(slug: job_profile_api.slug)
    job_profile.update_attributes(
      description: job_profile_api.overview,
      recommended: true,
      content: job_profile_api.body,
      last_updated: job_profile_api.last_updated,
      salary_min: job_profile_api.salary_starter,
      salary_max: job_profile_api.salary_experienced,
      alternative_titles: job_profile_api.alternative_titles,
      soc: job_profile_api.soc,
      onet_occupation_code: job_profile_api.onet_occupation_code
    )

    job_profile.v2_skills = job_profile_api.skills.map do |skill|
      s = V2Skill.find_or_create_by(name: skill.description)
      s.update_attributes(
        onet_rank: skill.onet_rank,
        onet_element_id: skill.onet_element_id,
        onet_attribute_type: skill.onet_attribute_type,
        level: 'onet'
      )
      s
    end

    job_profile.save!
    job_profile.v2_skills << V2Skill.find_or_create_by(name: job_profile_api.digital_skill, level: 'digital')
  end
end

class JobProfileAPI
  attr_reader :body
  def initialize(body)
    @body = body
  end

  def title
    body['Title']
  end

  def source_url
    body['Url']
  end

  def slug
    body['Url'].match(%r{job-profiles/(.*)$})[1]
  end

  def soc
    body['Soc']
  end

  def onet_occupation_code
    body['ONetOccupationalCode']
  end

  def alternative_titles
    body['AlternativeTitle']
  end

  def overview
    body['Overview']
  end

  def salary_starter
    body['SalaryStarter']
  end

  def salary_experienced
    body['SalaryExperienced']
  end

  def last_updated
    body['LastUpdatedDate']
  end

  # def minimum_hours
  #   body['MinimumHours']
  # end

  # def maximum_hours
  #   body['MaximumHours']
  # end

  # def working_hour_details
  #   body['WorkingHoursDetails']
  # end

  # def working_pattern
  #   body['WorkingPattern']
  # end

  # def working_pattern_details
  #   body['WorkingPatternDetails']
  # end

  def career_path_and_progression
    body['CareerPathAndProgression']['CareerPathAndProgression']
  end

  def day_to_day_tasks
    body['WhatYouWillDo']['WYDDayToDayTasks'].split(/[:;]/)
  end

  def working_environment
    body['WhatYouWillDo']['WorkingEnvironment']['Location']
  end

  def digital_skill
    body['WhatItTakes']['DigitalSkillsLevel']
  end

  def skills
    body['WhatItTakes']['Skills'].map do |skill|
      SkillAPI.new(skill)
    end
  end

  def resrtictions_and_requirements_related
    body['WhatItTakes']['RestrictionsAndRequirements']['RelatedRestrictions']
  end

  def resrtictions_and_requirements_other
    body['WhatItTakes']['RestrictionsAndRequirements']['OtherRequirements']
  end

  def apprenticeship
    body['HowToBecome']['EntryRoutes']['Apprenticeship']['RelevantSubjects']
  end

  def work
    body['HowToBecome']['EntryRoutes']['Work']
  end

  def direct_application
    body['HowToBecome']['EntryRoutes']['DirectApplication']
  end

  def related_job_profiles
    body['RelatedCareers'].map {|r| r['Url'].match(%r{job-profiles/(.*)$})[1] }
  end
end

class SkillAPI
  attr_reader :body
  def initialize(body)
    @body = body
  end

  def description
    body['Description']
  end

  def onet_rank
    body['ONetRank']
  end

  def onet_element_id
    body['ONetElementId']
  end

  def onet_attribute_type
    body['ONetAttributeType']
  end

  def level
    'onet'
  end
end
