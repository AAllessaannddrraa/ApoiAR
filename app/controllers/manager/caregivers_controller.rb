# app/controllers/manager/caregivers_controller.rb
module Manager
  class CaregiversController < ApplicationController
    def index
      @caregivers = Caregiver.all
    end

    def show
      @caregiver = Caregiver.find(params[:id])
    end
  end
end
