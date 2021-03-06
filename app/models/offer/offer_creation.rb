class OfferCreation
  attr_reader :offer

  def initialize service_request, user
    @user   = user
    @offer  = Offer.new service_request: service_request, user: user
    @valid  = false
  end

  def create
    if @valid
      @offer.save
      @offer
    end
  end

  def valid_creation?
    if @offer.valid?
      validate_bidder_is_not_service_request_owner
      validate_service_request_is_open
    end
    @valid = @offer.errors.empty?
  end

  private
    def validate_bidder_is_not_service_request_owner
      if bidder_is_service_request_owner?
        @offer.errors.add(:cant_make_offer, "in your own service request")
      end
    end

    def bidder_is_service_request_owner?
      @offer.user == @offer.service_request.user
    end

    def validate_service_request_is_open
      unless service_request_open?
        @offer.errors.add(:closed, "service request")
      end
    end

    def service_request_open?
      @offer.service_request.open?
    end

end
