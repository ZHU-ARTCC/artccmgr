# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

  if $('#new_event').length

    # Adds position select forms
    addPosition = ->
      newdiv = $('.more_group:last').clone()
      newid = Number(newdiv.attr('id').replace(/^event_event_positions_attributes_(\d+)_callsign/, '$1')) + 1
      newdiv.attr 'id', 'event_event_positions_attributes_' + newid
      $.each newdiv.find(':input'), ->
        thisname = $(this).attr('id')
        thisname = thisname.replace(/\d+/, newid)
        $(this).attr 'name', thisname
        $(this).attr 'id', thisname
        $(this).val ''
        return
      $('#groups').append newdiv
      return


    # Disables previous selection in other dropdowns
    $('.event-positions').on('cocoon:before-insert', (e, positionToBeAdded) ->
      assignedPositions = []
      $(document).find('.nested-fields select').each ->
        assignedPositions.push $(this).val()

      $.each assignedPositions, (index, positionId) ->
        if positionId != ''
          positionToBeAdded.find("option[value='#{positionId}']").attr('disabled', true)

    )

    $(".position-options").change (e) ->
      assignedPositions = []
      $(document).find('.position-options select').each ->
        console.log 'here'
        thisSelect = $(this)
        if thisSelect.val() != ''
          assignedPositions.push thisSelect.val()

        if assignedPositions.length == 0
          thisSelect.parents('.position-options select').siblings().find("option").attr('disabled', false)
        else
          $.each assignedPositions, (index, positionId) ->
            thisSelect.parents('.position-options select').siblings().find("option[value='#{positionId}']").attr('disabled', true)
