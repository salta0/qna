class NotificationMailer < ApplicationMailer
  def answer_notification(user, answer)
    @greeting = "Hi #{user.email}"
    @question = answer.question

    mail to: user.email
  end
end
