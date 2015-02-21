class OffersController < ApplicationController
  before_action :logged_in_user, :get_notifications
  before_action :set_service_request, only: [:create] 

  def create
    @creator = OfferCreation.new(@service_request, current_user)

    respond_to do |format|
      if @creator.valid_creation?
        @offer = @creator.create
        flash[:success] = "Tu oferta ha sido creada"
        notify_user
      else
        @offer = @creator.offer
        flash[:danger]  = "Ocurrio un error creando la oferta"
      end
      format.html { redirect_to @offer.service_request || root_url }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_request
      @service_request = ServiceRequest.find(params[:service_request_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offer_params
      params.require(:offer).permit()
    end

    def notify_user
      server = @offer.user
      client = @offer.service_request.user
      @offer.create_activity action: 'new', recipient: client, owner: server
      send_notification client.id, 'new_offer'
    end
end
