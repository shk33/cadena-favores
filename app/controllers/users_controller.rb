class UsersController < ApplicationController
  layout 'site/site', only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, except: [:new, :create]
  before_action :have_account, only: [:new, :create]
  before_action :get_notifications, only: [:show, :edit, :settings]
  # GET /users
  # GET /users.json
  def index
    if params[:search_type] == '2'
      @users = User.search_by_tag(params[:tag]).
                                              page(params[:page]).per(5)
    else
      @users = User.search_by_name(params[:search]).
                                              page(params[:page]).per(5)
    end
  end

  def my_profile
    @user = current_user
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if @user == current_user 
      @tags = Tag.all
    else
      redirect_to root_url
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      login @user
      redirect_to root_url
    else
      render "new"
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find params[:id]
    if @user == current_user 
      if @user.update_attributes user_params
        flash[:success] = "Perfil Actualizado"
        redirect_to @user
      else
        @tags = Tag.all
        render 'edit'
      end
    else
      redirect_to root_url
    end

  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    current_user.destroy
    redirect_to site_root_url
  end

  def following
    @user = User.find(params[:id])
    @following = @user.following.page(params[:page]).per(5)
  end

  #Show settings account
  def settings
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, 
                                   :email, 
                                   :password, 
                                   :password_confirmation, 
                                   { profile_attributes: [ :id, :description  ] })
    end
end
