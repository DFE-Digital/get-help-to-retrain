# TODO: Most of the xpath expressions within this class will be migrated to JobProfileScraper over time
# which should remove the need to disable rubocop rules here.
class JobProfileDecorator < SimpleDelegator # rubocop:disable Metrics/ClassLength
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::NumberHelper
  include ActionView::Context

  # rubocop:disable Metrics/LineLength
  HOW_TO_BECOME_XPATH = "//h2[contains(@class, 'job-profile-heading')]".freeze
  WORKING_HOURS_XPATH = "//div[@id='WorkingHours']//p[@class='dfc-code-jphours']".freeze
  WORKING_HOURS_PATTERNS_XPATH = "//div[@id='WorkingHoursPatterns']//p[@class='dfc-code-jpwpattern']".freeze
  ADDITIONAL_COPY_XPATH = "//header[@class='job-profile-hero']//div[@class='column-desktop-two-thirds']/p".freeze

  SECTIONS_XPATH = {
    apprenticeship: "//section[@id='Apprenticeship']/div[@class='job-profile-subsection-content']",
    direct_application: "//section[@id='directapplication']",
    work: "//section[@id='work']",
    day_to_day_tasks: "//section[@id='WhatYouWillDo']//section[contains(@class, 'job-profile-subsection') and not(contains(@id, 'workingenvironment'))]",
    working_environment: "//section[@id='WhatYouWillDo']//section[contains(@class, 'job-profile-subsection') and contains(@id, 'workingenvironment')]",
    career_path: "//section[@id='CareerPathAndProgression']",
    restrictions_and_requirements: "//section[@id='Skills']//section[contains(@class, 'job-profile-subsection') and (contains(@id, 'restrictions'))]",
    career_tips: "//section[contains(@class, 'job-profile-subsection') and contains (@id, 'moreinfo')]//div[@class='job-profile-subsection-content']",
    other_routes: "//section[contains(@class, 'job-profile-subsection') and contains (@id, 'otherroutes')]"
  }.freeze
  # rubocop:enable Metrics/LineLength

  def self.decorate(job_profiles)
    job_profiles.map { |job_profile| new(job_profile) }
  end

  def how_to_become
    html_body.xpath(HOW_TO_BECOME_XPATH).text
  end

  def salary_range # rubocop:disable Metrics/MethodLength
    return 'Variable' unless salary_min && salary_max

    content_tag(:div, class: 'govuk-grid-row salary-container') {
      column_data(
        content: number_to_currency(salary_min, precision: 0) + tag(:br) + '(starter)',
        content_classes: 'salary-range'
      ) +
        column_data(
          content: ' – ',
          column_classes: 'salary-separator-container',
          content_classes: 'salary-separator'
        ) +
        column_data(
          content: number_to_currency(salary_max, precision: 0) + tag(:br) + '(experienced)',
          content_classes: 'salary-range'
        )
    }.html_safe
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

  def additional_hero_copy
    html_body.xpath(ADDITIONAL_COPY_XPATH).children.map(&:text)
  end

  def section(key)
    return unless (xpath = SECTIONS_XPATH[key])

    @doc = html_body.xpath(xpath)

    return '' unless @doc.any?

    mutate_apprenticeship_content if key == :apprenticeship
    mutate_html_body

    @doc.to_html.gsub(%r{<a.*?>(.+?)</a>}, '\1').concat(separator_line)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def growth_icon
    return '' unless growth

    return 'arrow-falling-icon' if growth <= -5
    return 'arrow-stable-icon' if growth > -5 && growth <= 5
    return 'arrow-growing-icon' if growth > 5 && growth <= 50

    'arrow-growing-strongly-icon'
  end

  def growth_type
    return unless growth

    return 'Falling' if growth <= -5
    return 'Stable' if growth > -5 && growth <= 5
    return 'Growing' if growth > 5 && growth <= 50

    'Growing strongly'
  end

  def growth_explanation
    return unless growth

    case growth
    when (-Float::INFINITY...-5) then I18n.t(:falling, scope: :job_growth_explanation)
    when -5...5 then I18n.t(:stable, scope: :job_growth_explanation)
    when 5...50 then I18n.t(:growing, scope: :job_growth_explanation)
    else I18n.t(:growing_strongly, scope: :job_growth_explanation)
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def skills_match(score) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    return unless score

    if score <= 25
      'Low'
    elsif score > 25 && score <= 50
      'Reasonable'
    elsif score > 50 && score <= 75
      'Good'
    elsif score > 75
      'Excellent'
    end
  end

  private

  def html_body
    @html_body ||= Nokogiri::HTML(content)
  end

  def mutate_apprenticeship_content
    entry_requirements = @doc.xpath("h4[.='Entry requirements']")
    entry_requirements.xpath('following-sibling::*').remove
    entry_requirements.remove
  end

  def mutate_html_body
    mutate_h2_tags
    mutate_h3_tags
    mutate_h4_tags
    mutate_p_tags
    mutate_ul_tags
  end

  def mutate_h2_tags
    @doc.xpath('h2').each do |h2|
      h2['class'] = 'govuk-heading-m'
    end
  end

  def mutate_h3_tags
    @doc.xpath('h3').each do |h3|
      h3.name = 'h2'
      h3['class'] = 'govuk-heading-m'
    end
  end

  def mutate_h4_tags
    @doc.xpath('h4').each do |h4|
      if h4.content == 'More information'
        h4.remove
      else
        h4.name = 'h2'
        h4['class'] = 'govuk-heading-m'
      end
    end
  end

  def mutate_p_tags
    @doc.xpath('.//p').each do |p|
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

  def column_data(content:, column_classes: nil, content_classes:)
    content_tag(:div, class: "govuk-grid-column-one-third #{column_classes}".strip) do
      content_tag(:p, content, class: content_classes)
    end
  end
end
