class ApplicationController < ActionController::Base
  protect_from_forgery
  helper:all
  helper_method :after_sign_in_path_for

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User)
      flash[:notice] = "Successfully Login!"
      profiles_path
    end
  end

  def is_login?
    unless current_user
      flash[:error] = "Please login"
      redirect_to '/'
    end
  end
end
