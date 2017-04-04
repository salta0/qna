class UsersController < ApplicationController
  before_action :authenticate_user!, only: :update
  before_action :load_user, except: [:index, :add_email, :finish_signup]
  before_action :set_auth_and_password, only: [:add_email, :finish_signup]

  skip_authorization_check

  def index
    respond_with(@users = User.all.page(params[:page]))
  end

  def show
    respond_with(@user)
  end

  def update
    authorize! :update, @user
    @user.update(user_params)
    respond_with(@user)
  end

  def add_email
    respond_with(@user = User.new)
  end

  def finish_signup
    if existing_user
      redirect_to root_path, notice: "Аккаунт успешно привязан к вашей учетной записи. Теперь вы можете входить в систему с помощью #{@provider.capitalize}."
    else
      @user = User.new(
        password: @password, password_confirmation: @password,
        email: user_params[:email]
      )
      if @user.save
        create_authorization_and_sign_in
        redirect_to root_path
      else
        render :add_email
      end
    end
  end

 private

  def set_auth_and_password
    @provider = session["devise.oauth_data"]['provider']
    @uid = session["devise.oauth_data"]['uid']
    @password = Devise.friendly_token[0, 20]
  end

  def existing_user
    if @user = User.find_by(email: user_params[:email])
      create_authorization_and_sign_in
      return true
    end
  end

  def create_authorization_and_sign_in
    @user.authorizations.create(provider: @provider, uid: @uid)
    sign_in(@user, :bypass => true)
  end

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :email, :name, :location, :description, :avatar, :remove_avatar
    )
  end
end
