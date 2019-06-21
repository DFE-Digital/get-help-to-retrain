class JobProfileScraper
  include Wombat::Crawler

  title css: 'h1.heading-xlarge'
  description css: '.column-desktop-two-thirds p'
  body 'css=body', :html
  skills 'css=#Skills ul li', :list
end
