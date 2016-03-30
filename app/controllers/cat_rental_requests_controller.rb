class CatRentalRequestsController < ApplicationController

  def new
    @cats = Cat.all
    render :new
  end

  def create
    request = CatRentalRequest.new(request_params)
    if request.save
      redirect_to cat_rental_request_url(request.cat_id)
    end
  end

  def show
    @request = CatRentalRequest.find(params[:id])
    render :show
  end

  def update
    @request = CatRentalRequest.find(params[:id])
    if params[:status] == "APPROVED"
      @request.approve!
    elsif params[:status] == "DENIED"
      @request.deny!
    end

    render :show
  end

  private
  def request_params
    params.require(:rental_request).permit(:cat_id, :start_date, :end_date)
  end

end
