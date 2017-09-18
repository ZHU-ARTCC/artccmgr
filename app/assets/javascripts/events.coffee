# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  addPosition = ->
    newdiv = $('.more_group:last').clone()
    newid = Number(newdiv.attr('id').replace(/event_positions_attributes_(\d+)/, '$1')) + 1
    newdiv.attr 'id', 'event_positions_attributes_' + newid
    $.each newdiv.find(':input'), ->
      thisname = $(this).attr('id')
      thisname = thisname.replace(/\d+/, newid)
      $(this).attr 'name', thisname
      $(this).attr 'id', thisname
      $(this).val ''
      return
    $('#groups').append newdiv
    return
