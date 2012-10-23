class SchoolsController < ApplicationController
  before_filter :is_school?, :except => ['edit', 'update']
  layout :get_school_layout
  def show
    @school = SchoolAdmin.find(params[:id])
    @students = User.where("school_admin_id = '#{current_school_admin.id}'").all
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
      redirect_to login_home_index_path
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
