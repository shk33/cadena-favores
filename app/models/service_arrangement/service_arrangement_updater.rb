class ServiceArrangementUpdater
  attr_accessor :points_transaction

  def initialize id, user
    @service_arrangement = ServiceArrangement.find id
    @user = user
    @client = @service_arrangement.client
    @server = @service_arrangement.server
    @points_transaction = nil
  end

  def valid_update?
    is_user_the_client?
  end

  def update
    @service_arrangement.update_attributes completed: true
    transfer_points
  end


  private
    def is_user_the_client?
      @service_arrangement.client == @user
    end

    def transfer_points
      create_points_transaction
      @points_transaction.transfer_points
    end

    def create_points_transaction
      @points_transaction = PointsTransaction.new sender: @client, 
                            receiver: @server,
                            amount:   @service_arrangement.service.cost,
                            service_arrangement: @service_arrangement
      @points_transaction.save
    end
end
