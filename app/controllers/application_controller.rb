class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include AuthHelper

  before_action :require_login, :current_user

  def home
    # Display the login link.
    login_url = get_login_url
    render html: "<a href='#{login_url}'>Log in and view my email</a>".html_safe
  end


  private
  def not_authenticated
    redirect_to login_path, alert: 'Please login first'
  end

  def current_user
    return unless session[:user_id]
    @user ||= User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
  end

  helper_method :current_user

  def require_login
    unless current_user
      flash[:error] = 'You are not logged in'
      redirect_to :login
    end
  end

end
