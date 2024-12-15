class ManagersController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery except: :dashboard_action
  before_action :set_support, only: [:edit, :update, :show, :destroy]

  def dashboard
    @supports = Support.includes(:skills, :equipments, :caregiver).all
    @supports_without_caregivers = @supports.select { |support| support.caregiver.nil? }
    @caregivers = Caregiver.all
  end

  def dashboard_action
    Rails.logger.info "Params received: #{params.inspect}"
    caregiver_id = params[:caregiver_id]
    support_id = params[:support_id]

    if caregiver_id.blank? || support_id.blank?
      flash[:error] = "Both Caregiver and Support must be selected."
      redirect_to manager_dashboard_path and return
    end

    caregiver = Caregiver.find(caregiver_id)
    support = Support.find(support_id)

    if support.update(caregiver: caregiver)
      flash[:success] = "Caregiver successfully assigned to support."
    else
      flash[:error] = "Failed to assign caregiver to support."
    end
    redirect_to manager_dashboard_path
  rescue ActiveRecord::RecordNotFound
    redirect_to manager_dashboard_path, alert: "Invalid caregiver or support."
  end

  def edit
  end

  def update
    if @support.update(support_params)
      redirect_to manager_support_path(@support), notice: 'Support was successfully updated.'
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    @support.destroy
    redirect_to manager_supports_path, notice: 'Support was successfully destroyed.'
  end

  private

  def set_support
    @support = Support.find(params[:id])
  end

  def support_params
    params.require(:support).permit(:name, :description)
  end
end
