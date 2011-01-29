class Users::OmniauthCallbacksController < ApplicationController
  def github
    @user = User.find_for_github_oauth(env['omniauth.auth'], current_user)

    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Github"
    sign_in_and_redirect @user, :event => :authentication
  end
end
