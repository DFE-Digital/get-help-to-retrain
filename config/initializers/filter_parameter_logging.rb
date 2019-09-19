# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  password
  first_name
  last_name
  gender
  birth_day
  birth_month
  birth_year
  postcode
  email
]
