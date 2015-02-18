class RelationshipsController < ApplicationController
  before_action :set_relationship, only: [:show,  :destroy]

  def index
  end

  def show
  end

  def new
  end

  #Lejos de su implementación final.
  #Implementación sólo para comprobar funcionamiento de notifiaciones
  def create
    @relationship = Relationship.new(relationship_params)

    if @relationship.save
      follower  = current_user
      following = User.find(params[:followed_id])
      @relationship.create_activity action: 'new', recipient: following, owner: follower
      send_notification following.id, 'new_relationship'
      #redirect_to @recipe, notice: "Comment was created."
    else
      #render :new
    end
    redirect_to root_url
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
