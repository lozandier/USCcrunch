class NotificationsController < ApplicationController
  before_filter :is_login?
  layout :get_layout

  def index
    @posts = Tweet.where("reply IS NOT NULL").paginate :page => params[:page], :per_page => 15
  end

  def posts
    @posts = Tweet.where("reply IS NULL").paginate :page => params[:page], :per_page => 15
  end
end
