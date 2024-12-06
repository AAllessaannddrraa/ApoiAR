class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone, :address, :notes])
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone, :address, :notes])
  end

  # Redireciona para o Dashboard após login
  def after_sign_in_path_for(_resource)
    manager_dashboard_path
  end
end
