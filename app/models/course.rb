class Course < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates_presence_of :title, :url, :provider, :topic, :postcode

end
