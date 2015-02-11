class ServiceArrangementsController < ApplicationController
  before_action :set_service_arrangement, only: [:show,  :destroy]

  def index
  end

  def show
  end

  def new
  end

  #Lejos de su implementación final.
  #Implementación sólo para comprobar funcionamiento de notifiaciones
  def create
    @service_arrangement = ServiceArrangement.new(service_arrangement_params)

    if @service_arrangement.save
      server = @service_arrangement.server
      @service_arrangement.create_activity action: 'accepted_offer', recipient: server, owner: current_user
      #redirect_to @recipe, notice: "Comment was created."
    else
      #render :new
    end
    redirect_to root_url
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_arrangement
      @service_arrangement = ServiceArrangement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_arrangement_params
      params.require(:service_arrangement).permit(:server_id, 
                                                  :start_date, 
                                                  :end_date)
    end
end
