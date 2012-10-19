class SchoolSessionsController < Devise::SessionsController

  def new
    super
  end

  def create
    resource = warden.authenticate!(:scope => resource_name)
    flash[:notice] = 'Signed in Successfully'
    redirect_to '/'
  end
end