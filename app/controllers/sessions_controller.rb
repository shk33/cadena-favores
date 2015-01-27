class SessionsController < ApplicationController
  layout "site/site"
  before_action :have_account, only: [:new, :create]
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    
    if @user && @user.authenticate(params[:session][:password])
      #redirct the user to show profile 
      login @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or root_url
    else
      #Create an error mesage
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to site_root_url
  end

end
