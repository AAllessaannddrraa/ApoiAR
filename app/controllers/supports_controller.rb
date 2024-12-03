class SupportsController < ApplicationController
  before_action :set_support, only: [:show, :edit, :update, :destroy]
  before_action :set_collections, only: [:new, :edit, :create, :update]

  def index
    @supports = Support.all
  end

  def show
  end

  def new
    @support = Support.new
  end

  def create
    @support = Support.new(support_params)
    if @support.save
      redirect_to @support, notice: 'Support was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @support.update(support_params)
      redirect_to @support, notice: 'Support was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @support.destroy
    redirect_to supports_url, notice: 'Support was successfully destroyed.'
  end

  private

  def set_support
    @support = Support.find(params[:id])
  end

  def set_collections
    @skills = Skill.all
    @equipments = Equipment.all
    @caregivers = Caregiver.all
  end

  def support_params
    params.require(:support).permit(:name, :description, skill_ids: [], equipment_ids: [], caregiver_id: [])
  end
end
