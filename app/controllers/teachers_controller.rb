class TeachersController < ApplicationController
  layout :get_school_layout, :except => ['edit', 'update']

  def new
    @school = SchoolAdmin.find(params[:school_id])
    @teacher = @school.users.new
  end

  def create
    @school = SchoolAdmin.find(params[:school_id])
    @teacher = @school.users.new(params[:user])
    @teacher.password = 'ashok123'
    @teacher.password_confirmation = 'ashok123'
    if @teacher.save
      @teacher.update_attribute(:role, 'teacher')
      @teacher.update_attribute(:confirmation_token,nil)
      @teacher.generate_password_reset_code
      flash[:notice] = "Sccessfully Send invitation to student"
      UserMailer.sent_teacher_invitation(@school,@teacher).deliver
      redirect_to school_path(@school)
    else
      flash[:error] = "Failed to Send Invitation"
      render :action => 'new'
    end
  end

  def edit
    @teacher = User.find(params[:id])
    if @teacher.reset_password_token != params[:reset_password_token]
      render :text => 'Invalid Token.',:layout => false
    end
  end

  def show
    @school = SchoolAdmin.find(params[:school_id])
    @user = User.find(params[:id])
    @posts = Tweet.where("user_id = '#{@user.id}' and reply IS NULL").order("created_at Desc").paginate :page => params[:page], :per_page => 10
    respond_to do |format|
      format.html {render :partial => "show", :layout => false if request.xhr?}
      format.js {render :partial => "show", :layout => false if request.xhr?}
    end
  end

  def update
    @teacher = User.find(params[:id])
    if @teacher.update_attributes(params[:user])
      @teacher.update_attribute(:reset_password_token,nil)
      @teacher.update_attribute(:confirmation_token,nil)
      @teacher.update_attribute(:username,'@'+@teacher.username)
      sign_in(@teacher, @teacher)
      redirect_to new_user_home_path(current_user)
    else
      flash.now[:error] = "Loggened in failed."
      render :action => 'edit'
    end
  end

  def username
    @username = User.find_by_username(params[:username])
    if !@username.present?
      render :update do |page|
        page<<"$('#username_error').html('');"
      end
    else
      render :update do |page|
        page<<"$('#username_error').text('User Name already exists choose another one..');"
      end
    end
  end

  def destroy
    @teacher = User.find(params[:id])
    if @teacher.destroy
      render :update do |page|
        flash[:notice] = "Successfully deleted this Teacher."
        page.reload
      end
    end
  end
end
