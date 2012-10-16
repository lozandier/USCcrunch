class Admin::SchoolsController < ApplicationController
  before_filter :is_admin?
  layout :get_layout?

  def new
    @school = School.new
  end

  def create
    @school = School.new(params[:school])
    if @school.save
      flash[:notice] = "Successfully create the school admin"
      UserMailer.send_school_invitation(@school).deliver
      redirect_to admin_dashboards_path
    else
      flash[:error] = "Failed to create school admin"
      render :action => 'new'
    end
  end
end
