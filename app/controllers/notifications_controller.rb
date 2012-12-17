class NotificationsController < ApplicationController
  before_filter :is_login?
  layout :get_layout

  def index
    @posts = Tweet.where("reply = #{true}").paginate :page => params[:page], :per_page => 8
    respond_to do |format|
      format.html {render :partial => "index", :layout => false if request.xhr?}
      format.js {render :partial => "index", :layout => false if request.xhr?}
    end
  end

  def announcements
    @user = User.find(params[:id])
    @header = params[:post_text].present? ? "#{params[:post_text].capitalize}" : " "
    @posts = Tweet.where("user_id = #{@user.id} and post_box = '#{params[:post_text]}'").paginate :page => params[:page], :per_page => 10
    respond_to do |format|
      format.js
    end
  end

end
