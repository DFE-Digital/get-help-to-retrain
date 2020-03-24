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

  describe '.user_not_authenticated_and_not_registered?' do
    before do
      helper.singleton_class.class_eval do
        def current_user; end

        def user_session
          UserSession.new(session)
        end
      end
    end

    it 'returns true if user is not authenticated or registered' do
      expect(helper).to be_user_not_authenticated_and_not_registered
    end

    it 'returns false if user is authenticated' do
      allow(helper).to receive(:current_user).and_return(create(:user))

      expect(helper).not_to be_user_not_authenticated_and_not_registered
    end

    it 'returns false if user is registered' do
      user_session = UserSession.new(session)
      user_session.registered = true

      expect(helper).not_to be_user_not_authenticated_and_not_registered
    end

    it 'returns false if user is registered and authenticated' do
      user_session = UserSession.new(session)
      user_session.registered = true
      allow(helper).to receive(:current_user).and_return(create(:user))

      expect(helper).not_to be_user_not_authenticated_and_not_registered
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

  describe '.target_job' do
    before do
      helper.singleton_class.class_eval do
        def user_session
          UserSession.new(session)
        end
      end
    end

    it 'returns JobProfile instance if target job id is set in session' do
      job_profile = create(:job_profile)
      user_session = UserSession.new(session)
      user_session.target_job_id = job_profile.id

      expect(helper.target_job).to eq(job_profile)
    end

    it 'returns nil if target job id no longer exists' do
      job_profile = create(:job_profile)
      user_session = UserSession.new(session)
      user_session.target_job_id = job_profile.id
      job_profile.destroy

      expect(helper.target_job).to be_nil
    end

    it 'returns nil if target job id not set in session' do
      expect(helper.target_job).to be_nil
    end
  end

  describe '.back_link' do
    it 'returns path in formatted link html if path exists under host' do
      helper.singleton_class.class_eval do
        def url_parser
          UrlParser.new('http://some-host.com/path', 'some-host.com')
        end
      end

      expect(helper.back_link).to eq('<a class="govuk-back-link" href="/path">Back</a>')
    end

    it 'returns root path in formatted link html if path does not exists under host' do
      helper.singleton_class.class_eval do
        def url_parser
          UrlParser.new('http://some-host.com/path', 'another-host.com')
        end
      end

      expect(helper.back_link).to eq('<a class="govuk-back-link" href="/">Back</a>')
    end
  end

  describe '.show_cookie_banner?' do
    let(:user_session) { UserSession.new(session) }

    before do
      helper.singleton_class.class_eval do
        def user_session
          UserSession.new(session)
        end
      end
    end

    it 'returns false if current page is the cookie policy' do
      allow(helper).to receive(:current_page?).and_return true

      expect(helper).not_to be_show_cookie_banner
    end

    it 'returns true if current page is not the cookie policy, and cookie is empty' do
      allow(helper).to receive(:current_page?).and_return false

      expect(helper).to be_show_cookie_banner
    end

    it 'returns true if current page is not cookie policy, ghtr cookie is present and no user session cookie present' do
      allow(helper).to receive(:current_page?).and_return false
      allow(helper).to receive(:cookies).and_return('_get_help_to_retrain_session' => true)

      expect(helper).to be_show_cookie_banner
    end

    it 'returns false if current page is not cookie policy, and both cookie and session are present' do
      allow(helper).to receive(:current_page?).and_return false
      allow(helper).to receive(:cookies).and_return('_get_help_to_retrain_session' => true)
      user_session.cookies = true

      expect(helper).not_to be_show_cookie_banner
    end
  end
end
