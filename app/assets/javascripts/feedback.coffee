# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

  # Check if Anonymous checkbox on Feedback form exists in the DOM
  # then monitor for changes to set name/email data
  #
  if $('#feedbackAnonymous').length
    originalName      = $('#feedbackName').value
    originalEmail     = $('#feedbackName').value
    originalCallsign  = $('#feedbackCallsign').value

    # Set fields to Anonymous mode
    setFeedbackAnonymousMode = ->
      $('#feedbackName').val 'Anonymous'
      $('#feedbackEmail').val 'Anonymous'
      $('#feedbackCallsign').val ''
      $('#feedbackCallsign').prop('disabled', true)

    # Unset fields from Anonymous mode and refill original data
    unsetFeedbackAnonymousMode = ->
      $('#feedbackName').val originalName
      $('#feedbackEmail').val originalEmail
      $('#feedbackCallsign').val originalCallsign
      $('#feedbackCallsign').prop('disabled', false)

    # Check state on page load in case of invalid form submission
    if $('#feedbackAnonymous').is(':checked')
      setFeedbackAnonymousMode()

    # Monitor the checkbox for change and set mode appropriately
    $('#feedbackAnonymous').change ->
      if @checked
        setFeedbackAnonymousMode()
      else
        unsetFeedbackAnonymousMode()
