class PointsTransactionsController < ApplicationController
  before_action :set_points_transaction, only: [:show,  :destroy]

  def index
  end

  def show
  end

  def new
  end

  #Lejos de su implementación final.
  #Implementación sólo para comprobar funcionamiento de notifiaciones
  def create
    @points_transaction = PointsTransaction.new(points_transaction_params)

    if @points_transaction.save
      receiver = @points_transaction.receiver
      sender   = @points_transaction.sender
      @points_transaction.create_activity action: 'new', recipient: receiver, owner: sender
      #redirect_to @recipe, notice: "Comment was created."
    else
      #render :new
    end
    redirect_to root_url
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_points_transaction
      @points_transaction = PointsTransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def points_transaction_params
      params.require(:points_transaction).permit()
    end
end
