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
    if params[:point] == '1d'
      @posts = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NULL and tweets.created_at BETWEEN '#{Date.today-1}' AND '#{Date.today}'").count
      @replies = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NOT NULL and tweets.created_at BETWEEN '#{Date.today-1}' AND '#{Date.today}'").count
      @favorites = Favorite.where("favorites.user_id = '#{@user.id}' and favorites.created_at BETWEEN '#{Date.today-1}' AND '#{Date.today}'").count
      @user_favorites = Favorite.where("favorites.user_id = '#{current_user.id}' and favorites.created_at BETWEEN '#{Date.today-1}' AND '#{Date.today}'").count
      @likesqw = []
      @likesqw1 = []
      @today = Time.now;
      (1..24).each do |time|
        n = 0
        p = 0
        Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{Date.today-1}' AND '#{Date.today}'").each do |user|
          if user.created_at.strftime("%H").to_i == time
            n = n+1
          end
        end
        Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{Date.today-1}' AND '#{Date.today}'").each do |user|
          if user.created_at.strftime("%H").to_i == time
            p = p+1
          end
        end
        @likesqw << [time,n]
        @likesqw1 << [time,p]
      end
    elsif params[:point] == '5d'
      @posts = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NULL and tweets.created_at BETWEEN '#{Date.today-5}' AND '#{Date.today}'").count
      @replies = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NOT NULL and tweets.created_at BETWEEN '#{Date.today-5}' AND '#{Date.today}'").count
      @favorites = Favorite.where("favorites.user_id = '#{@user.id}' and favorites.created_at BETWEEN '#{Date.today-5}' AND '#{Date.today}'").count
      @user_favorites = Favorite.where("favorites.user_id = '#{current_user.id}' and favorites.created_at BETWEEN '#{Date.today-5}' AND '#{Date.today}'").count
      @likesqw = []
      @likesqw1 = []
      @time = Time.now.strftime("%d").to_i
      k = 0
      c = 5
      (1..5).each do |time|
        @likes = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{Date.today-c}' AND '#{Date.today-c+1}'").count
        @clikes = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{Date.today-c}' AND '#{Date.today-c+1}'").count
        k = k+1
        @date = (Date.today-c).strftime("%d").to_i
        @likesqw << [@date,@likes]
        @likesqw1 << [@date,@clikes]
        c = c-1
      end
    elsif params[:point] == '1m'
      @posts = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NULL and tweets.created_at BETWEEN '#{Date.today-31}' AND '#{Date.today}'").count
      @replies = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NOT NULL and tweets.created_at BETWEEN '#{Date.today-31}' AND '#{Date.today}'").count
      @favorites = Favorite.where("favorites.user_id = '#{@user.id}' and favorites.created_at BETWEEN '#{Date.today-31}' AND '#{Date.today}'").count
      @user_favorites = Favorite.where("favorites.user_id = '#{current_user.id}' and favorites.created_at BETWEEN '#{Date.today-31}' AND '#{Date.today}'").count
      @likesqw = []
      @likesqw1 = []
      @time = Time.now.strftime("%d").to_i
      k = 0
      c = 31
      (1..31).each do |time|
        @likes = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{Date.today-c}' AND '#{Date.today-c+1}'").count
        @clikes = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{Date.today-c}' AND '#{Date.today-c+1}'").count
        k = k+1
        @date = (Date.today-c).strftime("%d").to_i
        @likesqw << [@date,@likes]
        @likesqw1 << [@date,@clikes]
        c = c-1
      end
    elsif params[:point] == '2m'
      @posts = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NULL and tweets.created_at BETWEEN '#{Date.today.ago(1.month).beginning_of_month}' AND '#{Date.today}'").count
      @replies = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NOT NULL and tweets.created_at BETWEEN '#{Date.today.ago(1.month).beginning_of_month}' AND '#{Date.today}'").count
      @favorites = Favorite.where("favorites.user_id = '#{@user.id}' and favorites.created_at BETWEEN '#{Date.today.ago(1.month).beginning_of_month}' AND '#{Date.today}'").count
      @user_favorites = Favorite.where("favorites.user_id = '#{current_user.id}' and favorites.created_at BETWEEN '#{Date.today.ago(1.month).beginning_of_month}' AND '#{Date.today}'").count
      @likesqw = []
      @likesqw1 = []
      count = 0
      (1..2).each do |time|
        month = Date.today.ago(count.month).beginning_of_month
        lamonth = Date.today.ago(count.month).end_of_month
        m = Date.today.ago(count.month).beginning_of_month.strftime("%m").to_i
        @likes = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{month}' AND '#{lamonth }'").count
        @clikes = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{month}' AND '#{lamonth}'").count
        @likesqw << [m,@likes]
        @likesqw1 << [m,@clikes]
        count = count+1
      end
    elsif params[:point] == '3m'
      @posts = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NULL and tweets.created_at BETWEEN '#{Date.today.ago(2.month).beginning_of_month}' AND '#{Date.today}'").count
      @replies = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NOT NULL and tweets.created_at BETWEEN '#{Date.today.ago(2.month).beginning_of_month}' AND '#{Date.today}'").count
      @favorites = Favorite.where("favorites.user_id = '#{@user.id}' and favorites.created_at BETWEEN '#{Date.today.ago(2.month).beginning_of_month}' AND '#{Date.today}'").count
      @user_favorites = Favorite.where("favorites.user_id = '#{current_user.id}' and favorites.created_at BETWEEN '#{Date.today.ago(2.month).beginning_of_month}' AND '#{Date.today}'").count
      @likesqw = []
      @likesqw1 = []
      count = 0
      (1..3).each do |time|
        month = Date.today.ago(count.month).beginning_of_month
        lamonth = Date.today.ago(count.month).end_of_month
        m = Date.today.ago(count.month).beginning_of_month.strftime("%m").to_i
        @likes = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{month}' AND '#{lamonth }'").count
        @clikes = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{month}' AND '#{lamonth}'").count
        @likesqw << [m,@likes]
        @likesqw1 << [m,@clikes]
        count = count+1
      end
    else
      @posts = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NULL ").count
      @replies = Tweet.where("tweets.user_id = '#{@user.id}' and reply IS NOT NULL ").count
      @favorites = Favorite.where("favorites.user_id = '#{@user.id}'").count
      @user_favorites = Favorite.where("favorites.user_id = '#{current_user.id}'").count
      @likesqw = []
      @likesqw1 = []
      c = 4
      (1..5).each do |time|
        puts  @date = (Date.today).strftime("%Y").to_i-c
        @time = Date.new(@date, 1).beginning_of_month
        @time1 = Date.new(@date, 12).end_of_month
        @likes = Tweet.where("tweets.user_id = '#{@user.id}' and tweets.created_at BETWEEN '#{@time}' AND '#{@time1}'").count
        @clikes = Tweet.where("tweets.user_id = '#{current_user.id}' and tweets.created_at BETWEEN '#{@time}' AND '#{@time1}'").count
        @likesqw << [@date,@likes]
        @likesqw1 << [@date,@clikes]
        c = c-1
      end
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    if @user.id != current_user.id
      flash[:error] = 'Access Denied.'
      redirect_to class_path(:school_name => current_user.school_admin.school,:id =>current_user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully Updated your Class details."
      redirect_to class_path(:school_name => current_user.school_admin.school,:id =>@user.id)
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
end
