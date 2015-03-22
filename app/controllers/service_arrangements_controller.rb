class ServiceArrangementsController < ApplicationController
  before_action :logged_in_user, :get_notifications
  before_action :set_service_arrangement, only: [:show, :destroy]

  def index
    @arrangements = current_user.owed_services.page(params[:page]).per(5)
  end

  def hired
    @arrangements = current_user.hired_services.page(params[:page]).per(5)
  end

  def hired_completed
    @arrangements = current_user.hired_services_completed.page(params[:page]).per(5)
  end

  def completed_services
    @user = User.find(params[:id])    
    @arrangements = @user.services_completed.page(params[:page]).per(5)
  end

  def show
    @service_arrangement = ServiceArrangement.find(params[:id])
    @service_request = @service_arrangement.offer.service_request
    @service = @service_request.service
  end

  def update
    updater = ServiceArrangementUpdater.new params[:id], current_user
    if updater.valid_update?
      updater.update
      flash[:success] = "Servicio marcado como Completado"
      send_new_transaction_notification updater.points_transaction
      redirect_to my_hired_completed_url
    else
      redirect_to root_url
    end
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
      send_notification server.id, 'accepted_offer'
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

    def send_new_transaction_notification points_transaction 
      receiver = points_transaction.receiver
      sender   = points_transaction.sender
      points_transaction.create_activity action: 'new', recipient: receiver, owner: sender
      send_notification receiver.id , 'new_points_transaction'
    end
end