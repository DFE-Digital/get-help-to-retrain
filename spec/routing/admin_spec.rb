require 'rails_helper'

RSpec.describe 'routes for admin pages', type: :routing do
  context 'when admin mode is enabled' do
    around do |example|
      Rails.configuration.admin_mode = true
      example.run
    ensure
      Rails.configuration.admin_mode = false
    end

    it 'successfully routes site root to admin/dashboard#index' do
      expect(get('/')).to route_to(controller: 'admin/dashboard', action: 'index')
    end

    it 'successfully routes /admin path to admin/dashboard#index' do
      expect(get('/admin')).to route_to(controller: 'admin/dashboard', action: 'index')
    end

    it 'successfully routes /admin/dashboard to admin/dashboard#index' do
      expect(get('/admin/dashboard')).to route_to(controller: 'admin/dashboard', action: 'index')
    end

    it 'successfully routes to admin/categories#index' do
      expect(get('/admin/categories')).to route_to(controller: 'admin/categories', action: 'index')
    end

    it 'successfully routes to admin/feedback_surveys#index' do
      expect(get('/admin/feedback_surveys')).to route_to(controller: 'admin/feedback_surveys', action: 'index')
    end

    it 'successfully routes to admin/job_profiles#index' do
      expect(get('/admin/job_profiles')).to route_to(controller: 'admin/job_profiles', action: 'index')
    end

    it 'successfully routes to admin/skills#index' do
      expect(get('/admin/skills')).to route_to(controller: 'admin/skills', action: 'index')
    end

    it 'successfully routes to admin/user_personal_data#index' do
      expect(get('/admin/user_personal_data')).to route_to(controller: 'admin/user_personal_data', action: 'index')
    end

    it 'does not route requests to main application' do
      expect(get('/steps')).not_to be_routable
    end
  end

  context 'when admin mode is disabled' do
    it 'successfully routes site root to home#index' do
      expect(get('/')).to route_to(controller: 'home', action: 'index')
    end

    it 'does not route /admin path' do
      expect(get('/admin')).not_to be_routable
    end

    it 'does not route /admin/dashboard path' do
      expect(get('/admin/dashboard')).not_to be_routable
    end

    it 'does not route /admin/categories' do
      expect(get('/admin/categories')).not_to be_routable
    end

    it 'does not route /admin/feedback_surveys' do
      expect(get('/admin/feedback_surveys')).not_to be_routable
    end

    it 'does not route /admin/job_profiles' do
      expect(get('/admin/job_profiles')).not_to be_routable
    end

    it 'does not route /admin/skills' do
      expect(get('/admin/skills')).not_to be_routable
    end

    it 'does not route /admin/user_personal_data' do
      expect(get('/admin/user_personal_data')).not_to be_routable
    end

    it 'routes requests to main application' do
      expect(get('/steps')).to route_to(controller: 'pages', action: 'task_list')
    end
  end
end
