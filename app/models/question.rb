class Question < ApplicationRecord
  paginates_per 10

  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  belongs_to :user

  validates :title, :body, :user_id, presence: true

  after_create :subscribe_owner

  private

  def subscribe_owner
    Subscription.create(question: self, user: self.user)
  end
end
