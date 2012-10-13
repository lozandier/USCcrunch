class SessionsController < Devise::SessionsController

  def new
    @users = User.all
    super
  end

  def create
    render :update do |page|
      resource = warden.authenticate!(:scope => resource)
      flash[:notice] = 'Signed in Successfully'
      page.redirect_to after_sign_in_path_for(current_user)
    end
  end


end
