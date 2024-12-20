# app/controllers/request_supports_controller.rb
class RequestSupportsController < ApplicationController
  before_action :set_request_support, only: %i[show edit update destroy]

  def index
    @request_supports = RequestSupport.all
  end

  def show
    @caregivers = Caregiver.all
    @matches = @caregivers.map do |caregiver|
      match_data = caregiver.matches_support?(@request_support)
      {
        caregiver: caregiver,
        match: match_data[:match],
        missing_skills: match_data[:missing_skills],
        missing_equipments: match_data[:missing_equipments],
        score: caregiver.match_score(@request_support)
      }
    end.sort_by { |match| -match[:score] }
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
    params.require(:request_support).permit(:requested_time, skill_ids: [], equipment_ids: [])
  end
end
