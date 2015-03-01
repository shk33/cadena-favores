class ServiceArrangementUpdater

  def initialize id, user
    @service_arrangement = ServiceArrangement.find id
    @user = user
  end

  def valid_update?
    is_user_the_client?
  end

  def update
    @service_arrangement.update_attributes completed: true
  end


  private
    def is_user_the_client?
      @service_arrangement.client == @user
    end
end
