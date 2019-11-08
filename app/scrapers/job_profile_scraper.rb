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

  skills "xpath=//section[@id='Skills']//section[contains(@class, 'job-profile-subsection') and not(contains(@id, 'restrictions'))]//li", :list # rubocop:disable Metrics/LineLength

  def reparse(content, &block)
    metadata[:page] = Mechanize::Page.new(nil, nil, content, 200, mechanize)
    begin
      block.call
    ensure
      metadata[:page] = nil
    end
  end
end
