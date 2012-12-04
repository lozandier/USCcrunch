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

  def update
    @teacher = User.find(params[:id])
    if @teacher.update_attributes(params[:user])
      @teacher.update_attribute(:reset_password_token,nil)
      @teacher.update_attribute(:confirmation_token,nil)
      @teacher.update_attribute(:username,'@'+@teacher.username)
      redirect_to student_login_home_index_path
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
end
