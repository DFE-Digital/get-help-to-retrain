require 'rails_helper'

RSpec.feature 'Google Analytics tracking' do
  scenario 'snippet is included when enabled in configuration' do
    allow(Rails.configuration).to receive(:google_analytics_tracking_id).and_return('FOO')

    visit(root_path)
    click_on('Accept all cookies')

    expect(page.source).to include("gtag('config', 'FOO')")
  end

  scenario 'snippet is not included when disabled in configuration' do
    allow(Rails.configuration).to receive(:google_analytics_tracking_id).and_return(nil)

    visit(root_path)
    click_on('Accept all cookies')

    expect(page.source).not_to include('gtag')
  end

  scenario 'snippet is not included when user only accepts necessary cookies' do
    allow(Rails.configuration).to receive(:google_analytics_tracking_id).and_return('FOO')

    visit(root_path)
    click_on('Accept necessary cookies only')

    expect(page.source).not_to include('gtag')
  end
end
