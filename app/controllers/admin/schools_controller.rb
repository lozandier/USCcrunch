class Admin::SchoolsController < ApplicationController
  before_filter :is_admin?
  layout :layout?

  def new
    @school = School.new
  end

  def index
    @schools = School.all
  end

  def create
    @school = School.new(params[:school])
    @school.password = 'kapil123'
    @school.password_confirmation = 'kapil123'
    if @school.save
      @school.generate_password_reset_code
      flash[:notice] = "Successfully create the school admin"
      UserMailer.send_school_invitation(@school).deliver
      redirect_to admin_dashboards_path
    else
      flash[:error] = "Failed to create school admin"
      render :action => 'new'
    end
  end
end
