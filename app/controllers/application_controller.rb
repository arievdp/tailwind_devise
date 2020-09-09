class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Uncomment below to force authentication for all controllers
  # before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    # For additional in app/views/devise/registrations/edit.html.erb
    # eg. devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  # Uncomment for redirect after login
  # def after_sign_in_path_for(resource)
  # # return the path based on resource
  #   '/dashboard'
  # end
end
