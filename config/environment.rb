# Load the Rails application.
require_relative 'application'

module Logging
  module RailsCompat
    def formatter
      self
    end

    def tagged(*_args)
      yield self
    end

    def current_tags
      []
    end
  end
end

# Initialize the Rails application.
Rails.application.initialize!
