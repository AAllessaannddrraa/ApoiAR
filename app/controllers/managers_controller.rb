class ManagersController < ApplicationController
  def dashboard
    @supports = Support.all
    @caregivers = Caregiver.all
  end
end
