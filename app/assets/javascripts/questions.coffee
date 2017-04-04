ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $('.edit-question').show()

  $('.voting').bind 'ajax:success', (e, data, status, xhr) ->
    object = $.parseJSON(xhr.responseText)
    $("#voting-for-#{object.name}-#{object.item_id}").replaceWith(JST['templates/vote'](object: object))

  $('#question-attachments-link').click (e) ->
    e.preventDefault()
    $(".attachments#question-attachments").show()

  $('#question-comments-link').click (e) ->
    e.preventDefault()
    $('.comments#question-comments').show()

  $("form.new_comment").unbind('submit').submit (e) ->
    if validate_form($("form.new_comment")) > 0
      return false

  $('.voting').hover (e) ->
    obj = $(this).data("obj")
    id = $(this).data("id")
    reset_btn = $('#voting-for-' + obj + '-' + id).children('.button-reset')
    reset_btn.show()

  $('.voting').mouseleave (e) ->
    $('.button-reset').hide()

  $('.close-link').click (e) ->
    e.preventDefault()
    $(this).parent().hide()


$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
