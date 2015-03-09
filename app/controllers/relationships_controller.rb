class RelationshipsController < ApplicationController
  before_action :set_relationship, only: [:show,  :destroy]
  before_action :logged_in_user, :get_notifications

  def create
    user = User.find(params[:followed_id])
    @relationship = current_user.follow(user)

    @relationship.create_activity action: 'new', recipient: user, owner: current_user
    send_notification user.id, 'new_relationship'
    
    redirect_to user
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    redirect_to user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relationship
      @relationship = Relationship.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relationship_params
      params.require(:relationship).permit()
    end
end
