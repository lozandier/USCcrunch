class StudentsController < ApplicationController
  layout :get_school_layout, :except => ['edit', 'update']
  def new
    @school = SchoolAdmin.find(params[:school_id])
    @student = @school.users.new
  end

  def create
    @school = SchoolAdmin.find(params[:school_id])
    @student = @school.users.new(params[:user])
    @student.password = 'ashok123'
    @student.password_confirmation = 'ashok123'
    if @student.save
      @student.update_attribute(:role, 'student')
      @student.generate_password_reset_code
      flash[:notice] = "Sccessfully Send invitation to student"
      UserMailer.sent_student_invitation(@school,@student).deliver
      redirect_to school_path(@school)
    else
      flash[:error] = "Failed to Send Invitation"
      render :action => 'new'
    end
  end

  def edit
    @student = User.find(params[:id])
    if @student.reset_password_token != params[:reset_password_token]
      render :text => 'Invalid Token.',:layout => false
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

  def update
    @student = User.find(params[:id])
    if @student.update_attributes(params[:user])
      @student.update_attribute(:reset_password_token,nil)
      @student.update_attribute(:confirmation_token,nil)
      redirect_to student_login_home_index_path
    else
      flash.now[:error] = "Loggened in failed."
      render :action => 'edit'
    end
  end

  def show
    @school = SchoolAdmin.find(params[:school_id])
    @user = User.find(params[:id])
    @posts = Tweet.where("user_id = '#{@user.id}' and reply IS NULL").order("created_at Desc").paginate :page => params[:index_page], :per_page => 10
  end

  def posts
    @school = SchoolAdmin.find(params[:school_id])
    @user = User.find(params[:id])
    @posts = Tweet.where("user_id = '#{@user.id}' and reply IS NULL").order("created_at Desc").paginate :page => params[:index_page], :per_page => 10
  end

  def followers
    @school = SchoolAdmin.find(params[:school_id])
    @user = User.find(params[:id])
    @post = @user.tweets.new(params[:tweet])
    @users = User.where("confirmation_token IS NULL and id != '#{@user.id}'")
    @followers = @user.received_follows.where("status = #{true}")
  end

  def following
    @school = SchoolAdmin.find(params[:school_id])
    @users = User.where("confirmation_token IS NULL")
    @user = User.find(params[:id])
    @post = @user.tweets.new(params[:tweet])
    @followers = Follow.where("status = #{true} and user_id = #{@user.id}")
  end

  def destroy
    @student = Student.find(params[:id])
    if @student.destroy
      render :update do |page|
        flash[:notice] = "Successfully deleted this Student."
        page.reload
      end
    end
  end
end
