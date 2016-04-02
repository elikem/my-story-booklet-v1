class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_user!
  before_filter :authorize_rack_mini_profiler

  # Devise -- login and logout paths
  def after_sign_in_path_for(resource)
    story_path(current_user.username)
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  # Rack Mini Profiler
  def authorize_rack_mini_profiler
    if (current_user.admin if current_user)
      Rack::MiniProfiler.authorize_request
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
  end

  def authenticate_admin_user
    :authenticate_user!

    unless current_user.try(:admin?)
      flash[:error] = 'Admin users only.'
      redirect_to story_path(current_user.username)
    end
  end
end
