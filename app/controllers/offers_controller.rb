class OffersController < ApplicationController
  before_action :set_offer, only: [:show,  :destroy]

  def index
  end

  def show
  end

  def new
  end

  #Lejos de su implementación final.
  #Implementación sólo para comprobar funcionamiento de notifiaciones
  def create
    @offer = Offer.new(offer_params)

    if @offer.save
      server = @offer.user
      client = @offer.service_request.user
      @offer.create_activity action: 'new', recipient: client, owner: server
      send_notification client.id, 'new_points_transaction'
    else

    end
    redirect_to root_url
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @service_arrangement = ServiceArrangement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offer_params
      params.require(:service_arrangement).permit(:user_id, 
                                                  :service_request_id)
    end
end
