class JobProfileScraper
  include Wombat::Crawler

  title css: 'h1.heading-xlarge'
  description css: '.column-desktop-two-thirds p'

  salary_min css: '#Salary p.dfc-code-jpsstarter/text()' do |min|
    min.gsub(/\D/, '').to_i if min =~ /\d/
  end

  salary_max css: '#Salary p.dfc-code-jpsexperienced/text()' do |max|
    max.gsub(/\D/, '').to_i if max =~ /\d/
  end

  alternative_titles css: 'h2.heading-secondary/text()[last()]'

  related_profiles 'css=.job-profile-related ul li a/@href', :list

  content 'css=body', :html

  # rubocop:disable Metrics/LineLength
  skills "xpath=//section[@id='Skills']//section[contains(@class, 'job-profile-subsection') and not(contains(@id, 'restrictions'))]//li", :list
  # rubocop:enable Metrics/LineLength
end
