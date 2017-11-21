# frozen_string_literal: true

module RosterHelper
  # Determines the certification status for a given User and Certification
  # and returns the appropriate CSS background class name for the view.
  #
  # Returns CSS background class as String
  #
  def cert_status_css(user, certification)
    endorsement = user.endorsements.find_by(certification: certification)
    return unless endorsement

    endorsement.solo? ? 'bg-warning' : 'bg-success'
  end # def cert_status_css

  # Creates the array of operating initials options dependent on the
  # preference to allow duplicate OIs or not
  def initials_options
    disabled = if Settings.unique_operating_initials
                 User.all.pluck(:initials).reject(&:nil?)
               else
                 false
               end

    options_for_select(('AA'..'ZZ').to_a,
                       selected: @user.initials,
                       disabled: disabled)
  end # def initials_options
end
