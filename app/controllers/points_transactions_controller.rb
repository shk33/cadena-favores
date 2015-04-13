class PointsTransactionsController < ApplicationController
  before_action :set_points_transaction, only: [:show,  :destroy]

  def index
    @sent_transactions     = current_user.sent_transactions
    @received_transactions = current_user.received_transactions
  end

  def show
  end

  def new
  end

  def create
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
