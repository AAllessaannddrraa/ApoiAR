# app/controllers/manager/supports_controller.rb
module Manager
  class SupportsController < ApplicationController
    def index
      @supports = Support.all
    end

    def show
      @support = Support.find(params[:id])
    end
  end
end
