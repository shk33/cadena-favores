class MessagesController < ApplicationController
    before_action :set_message, only: [:show,  :destroy]

  def index
  end

  def show
  end

  def new
  end

  #Lejos de su implementación final.
  #Implementación sólo para comprobar funcionamiento de notifiaciones
  def create
    @message = Message.new(message_params)

    if @message.save
      sender = current_user
      receiver = @message.receiver_user sender
      @message.create_activity action: 'new', recipient: receiver, owner: sender
      send_notification receiver.id , 'new_message' 
    else
      #render :new
    end
    redirect_to root_url
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit()
    end
end
