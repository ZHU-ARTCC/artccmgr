# Load the Rails application.
require_relative 'application'

# Turn off field_with_errors wrappers
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end

# Initialize the Rails application.
Rails.application.initialize!

