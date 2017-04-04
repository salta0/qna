class User < ActiveRecord::Base
  paginates_per 10

  has_many :answers
  has_many :questions
  has_many :votes
  has_many :comments
  has_many :authorizations
  has_many :subscriptions, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  def author_of?(item)
    item.user_id == self.id
  end

  def voted?(obj)
    return obj.votes.find_by(user_id: self.id).present?
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    if auth.info && auth.info[:email]
      email = auth.info[:email]
      user = User.find_by(email: email)
      if user
        user.create_authorization(auth)
      else
        password = Devise.friendly_token[0, 20]
        user = User.create(email: email, password: password, password_confirmation: password)
        user.create_authorization(auth)
      end
      return user
    else
      return nil
    end
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
  end

  def subscribed?(question)
    question.subscriptions.where(user: self).exists?
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
     end
  end
end
