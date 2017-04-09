class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  default_scope -> { order(best: :desc).order(created_at: :desc) }

  after_commit :send_answer_notification

  def set_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  private

  def send_answer_notification
    AnswerNotificationJob.perform_later(self)
  end
end
