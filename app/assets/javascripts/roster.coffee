# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

# Check if VATUSA remove checkbox on Delete exists in the DOM
# then monitor for changes to make reason input appear/disappear
#
  if $('#vatusa_remove').length
    # Show reason text box
    showReason = ->
      $('#vatusa_reason').prop('required', true)
      $('#vatusa_reason').show()

    # Hide reason text box
    hideReason = ->
      $('#vatusa_reason').prop('required', false)
      $('#vatusa_reason').hide()

    # Check state on page load in case of invalid form submission
    if $('#vatusa_remove').is(':checked')
      showReason()
    else
      hideReason()

    # Monitor the checkbox for change show/hide input appropriately
    $('#vatusa_remove').change ->
      if @checked
        showReason()
      else
        hideReason()