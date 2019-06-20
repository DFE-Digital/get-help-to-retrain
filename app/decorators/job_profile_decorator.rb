class JobProfileDecorator < SimpleDelegator
  SALARY_MIN_XPATH = "//div[@id='Salary']//p[@class='dfc-code-jpsstarter']".freeze
  SALARY_MAX_XPATH = "//div[@id='Salary']//p[@class='dfc-code-jpsexperienced']".freeze
  WORKING_HOURS_XPATH = "//div[@id='WorkingHours']//p[@class='dfc-code-jphours']".freeze
  WORKING_HOURS_PATTERNS_XPATH = "//div[@id='WorkingHoursPatterns']//p[@class='dfc-code-jpwpattern']".freeze
  HERO_COPY_XPATH = "//header[@class='job-profile-hero']//h1[@class='heading-xlarge']".freeze
  SUB_HERO_COPY_XPATH = "//header[@class='job-profile-hero']//h2[@class='heading-secondary']".freeze
  ADDITIONAL_COPY_XPATH = "//header[@class='job-profile-hero']//div[@class='column-desktop-two-thirds']/p".freeze

  def salary
    {
      min: html_body.xpath(SALARY_MIN_XPATH).children[0].text.strip,
      max: html_body.xpath(SALARY_MAX_XPATH).children[0].text.strip
    }
  end

  def working_hours
    html_body.xpath(WORKING_HOURS_XPATH)
             .children[0]
             .text
             .strip
             .gsub('to', '-')
             .delete(' ')
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

  private

  def html_body
    @html_body ||= Nokogiri::HTML(__getobj__ .content)
  end
end
