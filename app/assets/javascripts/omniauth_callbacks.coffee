# All of the login U2F functions are handled in javascripts/u2f/coffee
# This is for detecting whether the OTP and U2F authentication prompt is
# present and presents the modal for user input.
#
$(document).on 'turbolinks:load', ->

  if $('#js-authenticate-u2f').length || $('#js-login-otp-form').length
    # Prevent the Modal from being closed
    $('#2faModal').modal
      backdrop: 'static'
      keyboard: false

    # Change focus to OTP entry on show
    $('#2faModal').on 'shown.bs.modal', ->
      $('#otp-code').trigger 'focus'

    # Add handler to auto-submit form after entering the code
#    $('#otp-code').keyup ->
#      if @value.length == 6
#        $('#js-login-otp-form').submit()

    # Display the Modal
    $('#2faModal').modal 'show'
