load Passwordless::Engine.root.join('app/models/passwordless/session.rb')
Passwordless::Session.class_eval do
  connects_to database: { writing: :restricted, reading: :restricted }
end
