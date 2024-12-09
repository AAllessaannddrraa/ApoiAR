# app/controllers/request_supports_controller.rb
class RequestSupportsController < ApplicationController
  before_action :set_request_support, only: %i[show edit update destroy]

  def index
    @request_supports = RequestSupport.all
  end

  def show
  end

  def new
    @request_support = RequestSupport.new
  end

  def edit
  end

  def create
    @request_support = RequestSupport.new(request_support_params)
    if @request_support.save
      redirect_to @request_support, notice: 'Request support was successfully created.'
    else
      render :new
    end
  end

  def update
    if @request_support.update(request_support_params)
      redirect_to @request_support, notice: 'Request support was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @request_support.destroy
    redirect_to request_supports_url, notice: 'Request support was successfully destroyed.'
  end

  private

  def set_request_support
    @request_support = RequestSupport.find(params[:id])
  end

  def request_support_params
    params.require(:request_support).permit(:requested_time, skill_ids: [])
  end
end
