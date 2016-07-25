class OauthConnectionsController < ApplicationController

  skip_before_filter :require_login

  def oauth
    login_at(params[:provider])
  end

  def callback
  end

  private
  def auth_params
  end

end
