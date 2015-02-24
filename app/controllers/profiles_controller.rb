class ProfilesController < ApplicationController

  def update
   @user = User.find params[:user_id]
   @profile = Profile.find params[:id]

   if @user == current_user 
    if @profile.update_attributes profile_params
      flash[:success] = "Categorias Actualizadas"
      redirect_to @user
    else
      render 'edit'
    end
  else
    redirect_to root_url
  end

  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(tag_ids: [])
    end
end
