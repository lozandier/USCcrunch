class ClassesController < ApplicationController
  before_filter :is_login?
  layout :get_layout

  def index
    
  end

  def switch_theme
    @user = User.find(params[:id])
    @user.update_attribute(:class_theme, params[:url])
    render :update do |page|
    end
  end

  def show
    @user = User.find(params[:id])
    @header = "Posts"
    @posts = Tweet.where("tweet_id IS NULL").order("created_at Desc").paginate :per_page => 20, :page => params[:page]
    respond_to do |format|
      format.html {render :partial => "show", :layout => false if request.xhr?}
      format.js {render :partial => "show", :layout => false if request.xhr?}
    end
  end

  def graphs
    @user = User.find(params[:id])
    @year = Time.now.strftime("%Y").to_i
    @next_year = @year+1
    @year1 = @year-1
    @year2 = @year1-1
    @year3 = @year2-1
    @year4 = @year3-1
    @year5 = @year4-1
    @year6 = @year5-1
    @year7 = @year6-1
    @today = Date.today;
    @time = @today.strftime("%Y").to_i;
    @time1 = @time-1;
    @time2 = @time1-1;
    @time3 = @time2-1;
    @time4 = @time3-1;
    @time5 = @time4-1;
    @likes = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{@year1}-12-31' AND '#{@next_year}-01-01'").count
    @likes1 = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{@year2}-12-31' AND '#{@year}-01-01'").count
    @likes2 = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{@year3}-12-31' AND '#{@year1}-01-01'").count
    @likes3 = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{@year4}-12-31' AND '#{@year2}-01-01'").count
    @likes4 = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{@year5}-12-31' AND '#{@year3}-01-01'").count
    @likes5 = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{@year6}-12-31' AND '#{@year4}-01-01'").count
    @clikes = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{@year1}-12-31' AND '#{@next_year}-01-01'").count
    @clikes1 = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{@year2}-12-31' AND '#{@year}-01-01'").count
    @clikes2 = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{@year3}-12-31' AND '#{@year1}-01-01'").count
    @clikes3 = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{@year4}-12-31' AND '#{@year2}-01-01'").count
    @clikes4 = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{@year5}-12-31' AND '#{@year3}-01-01'").count
    @clikes5 = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{@year6}-12-31' AND '#{@year4}-01-01'").count
    respond_to do |format|
      format.js
    end
  end

  def edit
    @user = User.find(params[:id])
    if @user.id != current_user.id
      flash[:error] = 'Access Denied.'
      redirect_to class_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully Updated your Class details."
      redirect_to class_path(@user)
    else
      flash[:error] = "Failed to Update your Class details."
      render :action => 'edit'
    end
  end

  def roster
    @user = User.find(params[:id])
    @users = User.where("role = 'student' and reset_password_token IS NULL")
  end

  def invite_students
    @user = User.find(params[:id])
  end

  def faqs
    @user = User.find(params[:id])
  end

  def readings
    @user = User.find(params[:id])
  end

  def importent_links
    @user = User.find(params[:id])
  end
end
