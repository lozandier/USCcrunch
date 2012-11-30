class NotificationsController < ApplicationController
  before_filter :is_login?
  layout :get_layout

  def index
    @posts = Tweet.where("reply IS NOT NULL").paginate :page => params[:page], :per_page => 10
    respond_to do |format|
      format.html {render :partial => "index", :layout => false if request.xhr?}
      format.js {render :partial => "index", :layout => false if request.xhr?}
    end
  end

  def posts
    @posts = Tweet.where("reply IS NULL").paginate :page => params[:page], :per_page => 10
    respond_to do |format|
      format.html {render :partial => "posts", :layout => false if request.xhr?}
      format.js {render :partial => "posts", :layout => false if request.xhr?}
    end
  end
end
