module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(value, user)
    votes.create(value: value, user_id: user)
  end

  def reset(user)
    vote = votes.find_by(user_id: user)
    vote.destroy
  end

  def rating
    return votes.sum(:value)
  end
end
  