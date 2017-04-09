class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question, touch: true

  validates :user_id, :question_id, presence: true
end
