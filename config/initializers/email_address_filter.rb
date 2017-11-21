# frozen_string_literal: true

# Email address filter
#
# Prevents sending email to certain destination email addresses.
# This is mostly used in the demo for "noreply@vatsim.net" addresses,
# however you can modify this if an issue arises where emails should be
# blocked to particular places.
#
class EmailAddressFilter
  def self.delivering_email(message)
    # Only do this in production - other environments catch all email
    return unless Rails.env.production?

    message.perform_deliveries = false

    # checks here; return if matched
    matched = message.to.join('').match(/noreply\@vatsim\.net/)

    if matched
      msg = "EmailAddressFilter: Filtered email for: #{matched.to_a.join(', ')}"
      Rails.logger.warn msg
      return
    end

    # otherwise, the email should be sent
    message.perform_deliveries = true
  end
end

ActionMailer::Base.register_interceptor(EmailAddressFilter)
