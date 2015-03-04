class OffersController < ApplicationController
  before_action :logged_in_user, :get_notifications
  before_action :set_service_request, only: [:create, :destroy, :new_accept, :accept] 
  before_action :set_offer,           only: [:destroy, :new_accept, :accept] 

  #GET new_accept
  def new_accept
    @arrengement = ServiceArrangement.new
    redirect_to root_url unless @service_request.user == current_user
  end

  #POST accept
  def accept
    if @offer.valid_acceptance? current_user
      if @offer.accept service_arrangement_params
        flash[:success] = "La oferta ha sido aceptada"
        send_new_arrengement_notification @offer.arrangement
        redirect_to @offer.service_request
      else
        @arrengement = @offer.arrangement
        render :new_accept
      end
    else
      flash[:danger] = "Ocurrio un error. Posiblemente la solicitud de servicio se encuentre cerrada."
      redirect_to root_url
    end

  end

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

  def destroy
    if current_user == @offer.user
      respond_to do |format|
        @offer.destroy
        flash[:success] = "Oferta Cancelada"
        format.html { redirect_to @service_request }
      end
    else
      redirect_to root_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_request
      @service_request = ServiceRequest.find(params[:service_request_id])
    end

    def set_offer
      @offer = Offer.find params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offer_params
      params.require(:offer).permit()
    end

    def service_arrangement_params
      params.require(:service_arrangement).permit(:start_date, 
                                                  :end_date)
    end

    def notify_user
      server = @offer.user
      client = @offer.service_request.user
      @offer.create_activity action: 'new', recipient: client, owner: server
      send_notification client.id, 'new_offer'
    end

    def send_new_arrengement_notification arrangement
      arrangement.create_activity action: 'accepted_offer', recipient: arrangement.server, owner: arrangement.client
      send_notification arrangement.server.id, 'accepted_offer'
    end
end
