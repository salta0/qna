class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]

    alias_action :update, :destroy, to: :modify
    can :modify, [Question, Answer, Comment], user: user

    can :destroy, Attachment, attachable: { user_id: user.id }

    can :set_best, Answer, question: { user_id: user.id }

    can :vote_reset, [Question, Answer] do |item|
      user.voted?(item)
    end

    alias_action :vote_up, :vote_down, to: :vote
    can :vote, [Question, Answer] do |item|
      !user.voted?(item)
    end

    cannot :vote, [Question, Answer], user: user

    can :me, User, id: user.id

    can :subscribe, Question do |question|
      !user.subscribed?(question)
    end
    can :unsubscribe, Question

    can :create, Subscription
    can :destroy, Subscription do |subscription|
      user.subscribed?(subscription.question)
    end

    can :update, User, id: user.id
  end
end
