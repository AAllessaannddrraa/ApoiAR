class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :about_us, :work_with_us, :contact, :send_contact, :request_support, :submit_support_request]
  def home
  end

  def about_us
  end

  def work_with_us
  end

  def contact
  end

  def request_support
  end

  def manager_dashboard
    @supports = Support.all
    @caregivers = Caregiver.all
  end

  def send_contact
    # Lógica para enviar o formulário de contato
    redirect_to contact_path, notice: 'Contact message sent successfully.'
  end

  def submit_support_request
    # Lógica para enviar o formulário de solicitação de apoio
    redirect_to request_support_path, notice: 'Support request submitted successfully.'
  end
end
