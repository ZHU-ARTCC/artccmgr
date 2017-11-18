# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

  # Check if New User form is present and attempt to populate data
  # from VATUSA API via roster#vatusa_info
  #
  if $('#new_user').length
    query_api = true

    $('#query_api').change ->
      if @checked
        query_api = true
        $('#query_api_btn').removeClass('btn-outline-info')
        $('#query_api_btn').addClass('btn-success')
        $('#query_api_status').text('Autofill On')
      else
        query_api = false
        $('#query_api_btn').removeClass('btn-success')
        $('#query_api_btn').addClass('btn-outline-info')
        $('#query_api_status').text('Autofill Off')

    $('#user_cid').change ->
      if $('#user_cid').val() > 0 && query_api
        cid = $('#user_cid').val()

        $.getJSON('/roster/' + cid + '/user_info.json').done((user_data) ->
          $('#user_name_first').val(user_data.name_first)
          $('#user_name_last').val(user_data.name_last)
          $('#user_email').val(user_data.email)
          $('#user_rating_id').val(user_data.rating).prop('selected', true)
          return
        ).fail (jqxhr, textStatus, error) ->
          $('#user_name_first').val('')
          $('#user_name_last').val('')
          $('#user_email').val('')
          $('#user_rating_id').val(0).prop('selected', true)
          return
      else
        $('#user_name_first').val('')
        $('#user_name_last').val('')
        $('#user_email').val('')
        $('#user_rating_id').val(0).prop('selected', true)

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