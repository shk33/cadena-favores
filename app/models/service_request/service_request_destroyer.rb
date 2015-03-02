class ServiceRequestDestroyer
  attr_reader :user

  def initialize service_request, user
    @user  = user
    @service_request = service_request
    @cost = @service_request.service.cost
  end

  def destroy
    @service_request.destroy
    @user.balance.unfreeze_points @cost
  end

  def deleteable_request?
    service_request_owner? && @service_request.open?
  end

  private
    def service_request_owner?
      @user == @service_request.user
    end
end
