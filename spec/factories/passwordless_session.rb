FactoryBot.define do
  factory :passwordless_session, class: Passwordless::Session do
    authenticatable_type { 'User' }
    timeout_at { Time.now + 1.hour }
    expires_at { Time.now + 1.year }
    remote_addr { '::1' }
    token { Faker::Crypto.md5 }
    user_agent { Faker::Alphanumeric.alpha }
  end
end
