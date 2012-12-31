class NotificationsController < ApplicationController
  before_filter :is_login?
  layout :get_layout

  def index
    @posts = Tweet.where("receiver_id = #{current_user.id} and post_box IS NULL and user_id != #{current_user.id}").order('created_at desc').paginate :page => params[:page], :per_page => 8
    respond_to do |format|
      format.html {render :partial => "index", :layout => false if request.xhr?}
      format.js {render :partial => "index", :layout => false if request.xhr?}
    end
  end

  def announcements
    @user = User.find(params[:id])
    @header = params[:post_text].present? ? "#{params[:post_text].capitalize}" : " "
    @posts = Tweet.where("tweet_id IS NULL and post_box = '#{params[:post_text]}'").order('created_at desc').paginate :page => params[:page], :per_page => 10
    respond_to do |format|
      format.js
    end
  end

end
