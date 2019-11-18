require 'rails_helper'

RSpec.describe 'routes for job vacancies', type: :routing do
  it 'successfully routes to get job_vacancies#index' do
    expect(get('/jobs-near-me')).to route_to(controller: 'job_vacancies', action: 'index')
  end

  it 'successfully routes to post job_vacancies#index' do
    expect(post('/jobs-near-me')).to route_to(controller: 'job_vacancies', action: 'index')
  end
end
