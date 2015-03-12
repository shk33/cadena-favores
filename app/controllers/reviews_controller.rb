class ReviewsController < ApplicationController
  before_action :logged_in_user, :get_notifications
  before_action :set_service_arrangment, only: [:new]

  def new
    @review = @arrangement.build_review
    redirect_to root_url unless @arrangement.client == current_user
  end

  private
    def set_service_arrangment
      @arrangement = ServiceArrangement.find(
                                    params[:service_arrangement_id])
    end
  
end
