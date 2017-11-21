# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "\"#{Settings.artcc_name}\" <#{Settings.mail_from}>"
  default subject: "#{Settings.artcc_name} Notification"
  layout 'mailer'

  # Override default mail method to automatically encrypt GPG
  # email notifications
  #
  # rubocop:disable Metrics/MethodLength
  def mail(headers = {}, &block)
    # Attempt to find user object for recipient
    user = User.find_by(email: headers[:to])

    # If the user has a GPG key change the subject
    if user.present? && user.gpg_enabled?
      # Change the subject of the email
      headers[:subject] = "Encrypted Notification from #{Settings.artcc_name}"

      # Use encryption when building the message
      headers[:gpg] = {
        encrypt:  true,
        keys:     { headers[:to] => user.gpg_key.key }
      }

      # Sign the email if GPG signatures are configured
      #
      gpg_key      = Rails.application.secrets.gpg_key
      gpg_password = Rails.application.secrets.gpg_passphrase

      if gpg_key.present?
        headers[:gpg][:sign_as]   = Settings.mail_from
        headers[:gpg][:password]  = gpg_password
      end
    end

    # Render the message
    Gitlab::Gpg::CurrentKeyChain.add(gpg_key)
    super(headers, &block)
  end
  # rubocop:enable Metrics/MethodLength

  def test(recipient)
    @user = recipient

    mail(to: @user.email) do |format|
      format.text { render plain: "#{self.class} Test Message" }
    end
  end
end
