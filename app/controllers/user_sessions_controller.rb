class UserSessionsController < ApplicationController

  # @spencer not sure if we should have this line of code
  # we may want the ability to destroy sessions that are broken
  # and i'm not sure if this prevents that - comment out if issues
  skip_before_action :require_login, except: [:destroy]


  def new
    #Shari: if statement to redirect signed in users from logging in
    if current_user != nil
      redirect_back_or_to(:users, alert: 'Already Logged In')
    end
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to(:users, notice: 'Login successful')
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(:users, notice: 'Logged out!')
  end
end
