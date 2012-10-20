class Admin::DashboardsController < ApplicationController
  before_filter :is_admin?
  layout :layout?

  def index
    @schools = School.all
    @students = User.all
  end
end
