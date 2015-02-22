class ServiceRequestUpdater
  attr_reader :service_request

  def initialize params, user
    @params = params
    @user   = user
    @service_request = ServiceRequest.new params
    @service_request.user = user
    @valid  = false
    @points = 0
  end

  def create
    @points = service_request.service.cost
    @service_request.save
    freeze_user_points
    @service_request
  end

  def valid_creation?
    if @service_request.valid?
      @points = @service_request.service.cost
      if user_has_enough_points?
        @valid = true
      end
    end    
  end

  private
    def freeze_user_points
      @user.balance.freeze_points @points
    end

    def user_has_enough_points?
      if @user.has_enough_points? @points
        true
      else
        @service_request.errors.add(:not_enough_points, "in your balance")
        false
      end
    end
end
