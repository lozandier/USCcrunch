class Admin::DashboardsController < ApplicationController
  before_filter :is_admin?
  layout :get_layout?

  def index
    @schools = School.all
  end
end
