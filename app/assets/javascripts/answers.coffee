ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    answer_id = $(this).data('answerId')
    $("#edit-form-#{answer_id}").show()

  $('.answer-attachments-link').click (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId');
    $('.attachments#answer-attachments-' + answer_id).show()

  $('.answer-comments-link').click (e) ->
    e.preventDefault()
    answer_id = $(this).data('answerId')
    $('.answer-comments#answer-comments-' + answer_id).show()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
