class JobProfileDecorator < SimpleDelegator # rubocop:disable Metrics/ClassLength
  include ActionView::Helpers::TagHelper

  SALARY_MIN_XPATH = "//div[@id='Salary']//p[@class='dfc-code-jpsstarter']".freeze
  SALARY_MAX_XPATH = "//div[@id='Salary']//p[@class='dfc-code-jpsexperienced']".freeze
  WORKING_HOURS_XPATH = "//div[@id='WorkingHours']//p[@class='dfc-code-jphours']".freeze
  WORKING_HOURS_PATTERNS_XPATH = "//div[@id='WorkingHoursPatterns']//p[@class='dfc-code-jpwpattern']".freeze
  HERO_COPY_XPATH = "//header[@class='job-profile-hero']//h1[@class='heading-xlarge']".freeze
  SUB_HERO_COPY_XPATH = "//header[@class='job-profile-hero']//h2[@class='heading-secondary']".freeze
  ADDITIONAL_COPY_XPATH = "//header[@class='job-profile-hero']//div[@class='column-desktop-two-thirds']/p".freeze
  APPRENTICESHIP_SECTION_XPATH = "//section[@id='Apprenticeship']".freeze
  DIRECT_APPLICATION_SECTION_XPATH = "//section[@id='directapplication']".freeze
  WORK_SECTION_XPATH = "//section[@id='work']".freeze
  SKILLS_SECTION_XPATH = "//section[@id='Skills']//section[contains(@class, 'job-profile-subsection') and not(contains(@id, 'restrictions'))]".freeze # rubocop:disable Metrics/LineLength
  WWYD_TASKS_SECTION_XPATH = "//section[@id='WhatYouWillDo']//section[contains(@class, 'job-profile-subsection') and not(contains(@id, 'workingenvironment'))]".freeze # rubocop:disable Metrics/LineLength
  WWYD_WORK_SECTION_XPATH = "//section[@id='WhatYouWillDo']//section[contains(@class, 'job-profile-subsection') and contains(@id, 'workingenvironment')]".freeze # rubocop:disable Metrics/LineLength
  CAREER_PATH_SECTION_XPATH = "//section[@id='CareerPathAndProgression']".freeze
  RESTRICTIONS_AND_REQUESTS_SECTION_XPATH = "//section[@id='Skills']//section[contains(@class, 'job-profile-subsection') and (contains(@id, 'restrictions'))]".freeze # rubocop:disable Metrics/LineLength
  CAREER_TIPS_SECTION_XPATH = "//section[contains(@class, 'job-profile-subsection') and contains (@id, 'moreinfo')]//div[@class='job-profile-subsection-content']".freeze # rubocop:disable Metrics/LineLength
  OTHER_ROUTES_SECTION_XPATH = "//section[contains(@class, 'job-profile-subsection') and contains (@id, 'otherroutes')]".freeze # rubocop:disable Metrics/LineLength

  def salary_range
    min_salary = html_body.xpath(SALARY_MIN_XPATH).children[0]

    return 'Variable' unless min_salary

    max_salary = html_body.xpath(SALARY_MAX_XPATH).children[0]

    "#{min_salary.text.strip} - #{max_salary.text.strip}"
  end

  def working_hours
    html_body.xpath(WORKING_HOURS_XPATH)
             .children[0]
             .text
             .strip
             .gsub('to', '-')
  end

  def working_hours_patterns
    html_body.xpath(WORKING_HOURS_PATTERNS_XPATH)
             .children[0]
             .text
             .strip
             .capitalize
  end

  def hero_copy
    html_body.xpath(HERO_COPY_XPATH).text.strip
  end

  def sub_hero_copy
    html_body.xpath(SUB_HERO_COPY_XPATH).text.strip
  end

  def additional_hero_copy
    html_body.xpath(ADDITIONAL_COPY_XPATH).children.map(&:text)
  end

  def section(xpath: nil)
    return unless xpath

    @doc = html_body.xpath(xpath).children

    return '' unless @doc.any?

    mutate_html_body

    @doc.to_html.concat(separator_line)
  end

  private

  def html_body
    @html_body ||= Nokogiri::HTML(__getobj__ .content)
  end

  def mutate_html_body
    mutate_h2_tags
    mutate_h3_tags
    mutate_h4_tags
    mutate_p_tags
    mutate_ul_tags
  end

  def mutate_h2_tags
    h2 = @doc.at_css('h2')

    return unless h2

    h2['class'] = 'govuk-heading-m'
  end

  def mutate_h3_tags
    @doc.xpath('//h3').each do |h3|
      h3.name = 'h2'
      h3['class'] = 'govuk-heading-m'
    end
  end

  def mutate_h4_tags
    @doc.xpath('//h4').each do |h4|
      if h4.content == 'More information'
        h4.remove
      else
        h4.name = 'h3'
        h4['class'] = 'govuk-heading-s'
      end
    end
  end

  def mutate_p_tags
    @doc.xpath('//p').each do |p|
      p['class'] = 'govuk-body-m'
    end
  end

  def mutate_ul_tags
    @doc.xpath("//div[@class='job-profile-subsection-content']/ul").each do |ul|
      if ul['class'] == 'list-link'
        ul.remove
      else
        ul['class'] = 'govuk-list govuk-list--bullet'
      end
    end
  end

  def separator_line
    content_tag :hr, nil, class: 'govuk-section-break govuk-section-break--m govuk-section-break--visible'
  end
end
