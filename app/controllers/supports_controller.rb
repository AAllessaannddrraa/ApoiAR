class SupportsController < ApplicationController
  before_action :set_support, only: [:show, :edit, :update, :destroy]
  before_action :set_collections, only: [:new, :edit, :create, :update]

  def index
    @supports = Support.includes(:caregiver).all

    # Suportes sem cuidadores atribuídos
    @supports_without_caregivers = @supports.select { |support| support.caregiver.nil? }
  end

  def show
    @caregivers = Caregiver.all
    @matches = @caregivers.map { |caregiver| { caregiver: caregiver, match: caregiver.matches_support?(@support) } }
  end

  def new
    @support = Support.new
  end

  def create
    @support = Support.new(support_params)
    @support.user = current_user
    if @support.save
      redirect_to supports_path, notice: 'Support was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @support.update(support_params)
      redirect_to supports_path, notice: 'Support was successfully updated.'
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
    params.require(:support).permit(:name,:caregiver_id, :description, skill_ids: [], equipment_ids: [])
  end
end
