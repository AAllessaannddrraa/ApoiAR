class ManagersController < ApplicationController
  def dashboard
    @supports = Support.all
    @caregivers = Caregiver.all
    @supports = Support.paginate(page: params[:supports_page], per_page: 10) # Exibe 10 supports por página
    @caregivers = Caregiver.paginate(page: params[:caregivers_page], per_page: 10) # Exibe 10 caregivers por página
  end
end
