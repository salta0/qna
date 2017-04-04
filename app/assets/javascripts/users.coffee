validate_form = (form) ->
  err_count = 0
  fields = form.find(".required > input")

  [].forEach.call fields, (v, i, a) ->
    if fields[i].value == ""
      $(this).addClass("error")
      $("<i class='error'> Обязательно к заполнению </i>").insertAfter(fields[i])
      err_count += 1

  return err_count

ready = ->
  $(".edit-user-link").click (e) ->
    e.preventDefault()
    $(".edit-user").show()

  $("form.edit_user").unbind('submit').submit (e) ->
    if validate_form($("form.edit_user")) > 0
      return false

$(document).ready(ready)
$(document).ready(validate_form)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
