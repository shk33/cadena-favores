class ServiceRequestUpdater
  attr_reader :service_request

  def initialize service_request, params
    @service_request = service_request
    @params = params
    @valid  = false
    @old_cost = service_request.service.cost
    @new_cost = @params[:service_attributes][:cost].to_i
    @cost_difference = @new_cost - @old_cost
  end

  def update
    @service_request.update_attributes @params
    if @cost_difference >= 0
      freeze_points_difference
    else
      unfreeze_points_difference
    end
    @service_request
  end

  def valid_update?
    byebug
    @service_request.assign_attributes @params
    if @service_request.valid?
      if new_cost_not_negative?
        if @cost_difference >= 0
          if user_has_enough_points?
            @valid = true;
          end
        else
          @valid = true;
        end
      else
        @service_request.errors.add(:cant_be_negative, "cost")
      end
    end  
    @valid
  end

  private
    def freeze_points_difference
      @service_request.user.balance.freeze_points @cost_difference
    end

    def unfreeze_points_difference
      @service_request.user.balance.freeze_points(@cost_difference)
    end

    def new_cost_not_negative?
      @new_cost >= 0
    end

    def user_has_enough_points?
      if @service_request.user.has_enough_points? @cost_difference
        true
      else
        @service_request.errors.add(:not_enough_points, "in your balance")
        false
      end
    end
end
