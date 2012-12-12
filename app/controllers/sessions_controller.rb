class SessionsController < Devise::SessionsController

  def new
    @users = User.all
    respond_to do |format|
      format.js
    end
  end

  def create
    render :update do |page|
      @user = User.find_by_email_and_role(params[:user][:email],params[:user][:role])
      if @user.present?
        resource = warden.authenticate!(:scope => resource_name)
        flash[:notice] = 'Signed in Successfully'
        page.redirect_to after_sign_in_path_for(current_user)
      else
        @role = params[:user][:role] == 'student' ? '#error' : '#error2'
        page<<"$('#{@role}').show();"
      end
    end
  end


end
