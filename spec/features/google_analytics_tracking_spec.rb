require 'rails_helper'

RSpec.feature 'Google Analytics tracking' do
  scenario 'snippet is included when enabled in configuration' do
    allow(Rails.configuration).to receive(:google_analytics_tracking_id).and_return('FOO')

    visit(root_path)

    expect(page.source).to match('gtag')
  end
  
  scenario 'snippet is not included when disabled in configuration' do
    allow(Rails.configuration).to receive(:google_analytics_tracking_id).and_return(nil)

    visit(root_path)

    expect(page.source).not_to match('gtag')
  end
end
