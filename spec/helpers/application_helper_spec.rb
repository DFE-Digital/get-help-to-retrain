require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '.page_title' do
    it 'returns correct translated page title' do
      helper.page_title(:home_index)
      expect(helper.content_for(:page_title)).to eq 'Get help to retrain - Home'
    end

    it 'warns of missing translations' do
      helper.page_title(:foo)
      expect(helper.content_for(:page_title)).to eq 'translation missing: en-GB.page_titles.foo'
    end
  end

  describe '.generate_breadcrumbs' do
    it 'returns current page list item' do
      expect(helper.generate_breadcrumbs('Current Page', [])).to match(/Current Page/)
    end

    it 'returns previous pages breadcrumbs' do
      expect(helper.generate_breadcrumbs('Current Page', [['Previous Page', '/']])).to match(/Previous Page/)
    end
  end

  describe '.user_not_authenticated_or_registered?' do
    before do
      helper.singleton_class.class_eval do
        def current_user; end

        def user_session
          UserSession.new(session)
        end
      end
    end

    it 'returns true if user is not authenticated or registered' do
      expect(helper).to be_user_not_authenticated_or_registered
    end

    it 'returns false if user is authenticated' do
      allow(helper).to receive(:current_user).and_return(create(:user))

      expect(helper).not_to be_user_not_authenticated_or_registered
    end

    it 'returns false if user is registered' do
      user_session = UserSession.new(session)
      user_session.registered = true

      expect(helper).not_to be_user_not_authenticated_or_registered
    end
  end

  describe '.user_not_authenticated?' do
    before do
      helper.singleton_class.class_eval do
        def current_user; end
      end
    end

    it 'returns true if user is not authenticated' do
      expect(helper).to be_user_not_authenticated
    end

    it 'returns false if user is authenticated' do
      allow(helper).to receive(:current_user).and_return(create(:user))

      expect(helper).not_to be_user_not_authenticated
    end
  end
end
