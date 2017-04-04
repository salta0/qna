class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :oauth

  def facebook
  end

  def twitter
    
  end

  private

  def oauth
    if request.env["omniauth.auth"]
      @user = User.find_for_oauth(request.env['omniauth.auth'])
      if @user
        sign_in_and_redirect @user, event: :authentification
        set_flash_message(:notice, :success, kind: "#{request.env['omniauth.auth']['provider'].capitalize}") if is_navigational_format?
      else
        session["devise.oauth_data"] = request.env["omniauth.auth"].except('extra') 
        redirect_to users_add_email_path
      end
    end
  end
end