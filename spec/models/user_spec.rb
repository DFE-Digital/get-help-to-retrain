require 'rails_helper'

RSpec.describe User do
  let(:client) { instance_spy(Notifications::Client) }

  before do
    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  describe '#register_new_user' do
    it 'sets the request session to the user' do
      user = create(:user)
      session = create(:session)
      user_session = UserSession.new(
        create_fake_session(id: session.session_id)
      )
      user.register_new_user(user_session, 'url')

      expect(user.session).to eq(session)
    end

    it 'sends a confirmation email' do
      user = create(:user)
      session = create(:session)
      user_session = UserSession.new(
        create_fake_session(id: session.session_id)
      )
      user.register_new_user(user_session, 'url')

      expect(client).to have_received(:send_email).with(confirmation_email(user.email))
    end

    it 'does nothing if no session set' do
      user = create(:user)
      user.register_new_user(nil, 'url')

      expect(client).not_to have_received(:send_email).with(confirmation_email(user.email))
    end

    it 'does nothing if no url set' do
      user = create(:user)
      session = create(:session)
      user_session = UserSession.new(
        create_fake_session(id: session.session_id)
      )
      user.register_new_user(user_session, nil)

      expect(user.session).to be_nil
    end
  end

  describe '#register_existing_user' do
    it 'persists passwordless_session' do
      user = create(:user)
      passwordless_session = build(:passwordless_session, authenticatable: user)
      user.register_existing_user(passwordless_session, 'url')

      expect(passwordless_session).to be_persisted
    end

    it 'sets the magic link url' do
      user = create(:user)
      passwordless_session = build(:passwordless_session, authenticatable: user)
      user.register_existing_user(passwordless_session, 'http://example.com')

      expect(client).to have_received(:send_email).with(
        hash_including(
          personalisation: {
            'LINK' => "http://example.com/sign-in/#{passwordless_session.token}"
          }
        )
      )
    end

    it 'sends a sign in email' do
      user = create(:user)
      passwordless_session = create(:passwordless_session, authenticatable: user)
      user.register_existing_user(passwordless_session, 'url')

      expect(client).to have_received(:send_email).with(sign_in_email(user.email))
    end

    it 'does nothing if no passwordless_session set' do
      user = create(:user)
      user.register_existing_user(nil, 'url')

      expect(client).not_to have_received(:send_email).with(sign_in_email(user.email))
    end

    it 'does nothing if no url set' do
      user = create(:user)
      passwordless_session = build(:passwordless_session)
      user.register_existing_user(passwordless_session, nil)

      expect(passwordless_session).not_to be_persisted
    end

    it 'does nothing if passwordless_session not valid' do
      user = create(:user)
      passwordless_session = build(:passwordless_session)
      user.register_existing_user(passwordless_session, 'url')

      expect(passwordless_session).not_to be_persisted
    end
  end

  describe '#restore_session' do
    it 'sets the current request session to the user' do
      user = create(:user, session: create(:session))
      session = create(:session)
      new_session = create_fake_session(id: session.session_id)

      user.restore_session(new_session)

      expect(user.session).to eq(session)
    end

    it 'overrides current session data set to user' do
      user = create(:user, session: create(:session, data: { postcode: 'bar' }))
      session = create(:session, data: { postcode: 'baz' })
      new_session = create_fake_session(id: session.session_id)

      user.restore_session(new_session)

      expect(user.session.data).to eq(session.data)
    end

    it 'does nothing if no user_session set' do
      user = create(:user)
      user.restore_session(nil)

      expect(user.session).to be_nil
    end
  end

  def confirmation_email(email)
    {
      email_address: email,
      template_id: NotifyService::CONFIRMATION_TEMPLATE_ID,
      personalisation: {
        'URL' => 'url'
      }
    }
  end

  def sign_in_email(email)
    {
      email_address: email,
      template_id: NotifyService::LINK_TO_RESULTS_TEMPLATE_ID,
      personalisation: {
        'LINK' => /sign-in/
      }
    }
  end
end
