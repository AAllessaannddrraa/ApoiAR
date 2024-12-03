class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@apoiar.com'
  layout 'mailer'

  def new_application(application_params)
    @application_params = application_params
    mail(to: 'manager@apoiar.com', subject: 'New Caregiver Application')
  end
end
