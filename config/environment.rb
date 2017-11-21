# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

# Turn off field_with_errors wrappers
ActionView::Base.field_error_proc = proc do |html_tag, _instance|
  # rubocop:disable Rails/OutputSafety
  html_tag.html_safe
  # rubocop:enable Rails/OutputSafety
end

# Initialize the Rails application.
Rails.application.initialize!
