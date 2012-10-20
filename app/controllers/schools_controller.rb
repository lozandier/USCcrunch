class SchoolsController < ApplicationController
  before_filter :is_school?, :except => ['edit', 'update']
  layout :get_school_layout
  def show
    @school = SchoolAdmin.find(params[:id])
    @students = Student.all
    @teachers = Teacher.all
  end

  def edit
    @school = SchoolAdmin.find(params[:id])
    if @school.reset_password_token != params[:reset_password_token]
      render :text => 'Invalid Token.',:layout => false
    end
  end

  def update
    @school = SchoolAdmin.find(params[:id])
    if @school.update_attributes(params[:school_admin])
      @school.update_attribute(:reset_password_token,nil)
      flash[:notice] = "Loggened in successful."
      sign_in(:school_admin, @school, :bypass => true)
      redirect_to school_path(current_school_admin)
    else
      flash.now[:notice] = "Loggened in failed."
      render :action => 'edit',:layout => false
    end
  end

  def destroy
    session[:school_id] = nil
    session.delete(:school_id)
    redirect_to root_path, :notice => "Logged out"
  end
end
