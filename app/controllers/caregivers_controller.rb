class CaregiversController < ApplicationController
  before_action :authenticate_user!
  before_action :set_caregiver, only: [:show, :edit, :update, :destroy, :manager_caregiver]
  before_action :set_skills, only: [:new, :edit, :create, :update]
  before_action :set_support, only: [:new, :create]

  def index
    @caregivers = Caregiver.all
  end

  def show
  end

  def new
    @support = Support.find(params[:support_id])
    @caregiver = @support.caregivers.new
  end

  def create
    @caregiver = @support.caregivers.new(caregiver_params)
    if @caregiver.save
      redirect_to manager_dashboard_path, notice: "Caregiver added successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @caregiver.update(caregiver_params)
      redirect_to @caregiver, notice: 'Caregiver was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @caregiver.destroy
    redirect_to caregivers_url, notice: 'Caregiver was successfully destroyed.'
  end

  def manager_index
    @caregivers = Caregiver.all
  end

  def manager_show
  end

  def manager_caregiver
    @caregiver = Caregiver.find(params[:id])
    # Your code here...
  end

  private

  def set_caregiver
    @caregiver = Caregiver.find(params[:id])
  end

  def set_skills
    @skills = Skill.all
  end

  def set_support
    @support = Support.find(params[:support_id])
  end

  def caregiver_params
    params.require(:caregiver).permit(:name, :email, :phone)
  end
end
