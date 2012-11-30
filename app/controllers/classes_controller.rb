class ClassesController < ApplicationController
  before_filter :is_login?
  layout :get_layout

  def index
    
  end

  def show
    @user = User.find(params[:id])
    @post = @user.tweets.new(params[:tweet])
    @posts = Tweet.find(:all, :group => :user_id,:order => "created_at Asc").paginate :page => params[:page], :per_page => 10
    respond_to do |format|
      format.html {render :partial => "show", :layout => false if request.xhr?}
      format.js {render :partial => "show", :layout => false if request.xhr?}
    end
  end
end
