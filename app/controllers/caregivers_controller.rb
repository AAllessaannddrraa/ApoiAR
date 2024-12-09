class CaregiversController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  before_action :set_skills_and_equipments, only: [:index, :new, :edit, :create, :update]
  before_action :set_caregiver, only: [:show, :edit, :update, :destroy]

  def index
    @caregivers = Caregiver.includes(:skills, :equipments).all

    # Filtros por habilidades e equipamentos
    if params[:skill_ids].present?
      skill_ids = params[:skill_ids].reject(&:blank?)
      @caregivers = @caregivers.joins(:skills)
                               .where(skills: { id: skill_ids })
                               .group('caregivers.id')
                               .having('COUNT(DISTINCT skills.id) >= ?', skill_ids.count)
    end

    if params[:equipment_ids].present?
      equipment_ids = params[:equipment_ids].reject(&:blank?)
      @caregivers = @caregivers.joins(:equipments)
                               .where(equipments: { id: equipment_ids })
                               .group('caregivers.id')
                               .having('COUNT(DISTINCT equipments.id) >= ?', equipment_ids.count)
    end

    # Identificar cuidadores sem suporte atribuído
    @caregivers_without_support = @caregivers.reject do |caregiver|
      Support.exists?(caregiver_id: caregiver.id)
    end
  end

  def show; end

  def new
    @caregiver = Caregiver.new
  end

  def create
    @caregiver = Caregiver.new(caregiver_params)
    if @caregiver.save
      flash[:notice] = "Caregiver added successfully."
      redirect_to manager_dashboard_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @caregiver.update(caregiver_params)
      redirect_to caregivers_path, notice: 'Caregiver was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @caregiver.destroy
    redirect_to caregivers_path, notice: 'Caregiver was successfully destroyed.'
  end

  private

  def set_caregiver
    @caregiver = Caregiver.find(params[:id])
  end

  def caregiver_params
    params.require(:caregiver).permit(:name, :email, :phone, skill_ids: [], equipment_ids: [])
  end

  def set_skills_and_equipments
    @skills = Skill.all
    @equipments = Equipment.all
  end
end
