class ReviewsController < ApplicationController
  before_action :logged_in_user, :get_notifications
  before_action :set_service_arrangment, only: [:new, :create, :edit, :update]

  def new
    if @arrangement.has_review?
      redirect_to edit_service_arrangement_review_path(@arrangement, @arrangement.review) 
    else
      @review = @arrangement.build_review
      redirect_to root_url unless @arrangement.client == current_user
    end
  end

  def create
    if current_user ==  @arrangement.client
      @review = Review.new review_params
      @review.service_arrangement = @arrangement
      @review.user = current_user
      if @review.save
        flash[:success] = "Servico Calificado Exitósamente"
        redirect_to @arrangement
      else
        render :new    
      end
    else
      redirect_to root_url
    end
  end

  def edit
    @review = @arrangement.review
  end

  def update
    if current_user ==  @arrangement.client
      @review = @arrangement.review
      if @review.update_attributes review_params
        flash[:success] = "Calificación actualizada correctamente"
        redirect_to @arrangement
      else
        render :edit
      end
    else
      redirect_to root_url
    end
  end

  private
    def set_service_arrangment
      @arrangement = ServiceArrangement.find(
                                    params[:service_arrangement_id])
    end

    def review_params
      params.require(:review).permit(:rating, :description)
    end
  
end
