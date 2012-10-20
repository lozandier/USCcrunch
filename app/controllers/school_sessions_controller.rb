class SchoolSessionsController < Devise::SessionsController
  layout :get_school_layout
  def new
  end

  def create
    puts "VVVVVVVVVVVV"
    resource = warden.authenticate!(:scope => resource_name)
    puts resource.errors.inspect
    puts "VVVVVVVVVVVBBBBBB"
    redirect_to after_sign_in_path_for(current_school_admin)
  end

  def destroy
    signed_in = signed_in?(resource_name)
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    flash[:notice] = "Logout Sucessfully."
    redirect_to "/"
  end
end