class ProfilesController < ApplicationController
  before_filter :is_login?
  layout :get_layout

  def index
    @users = User.where("reset_password_token IS NULL and id != '#{current_user.id}'")
    @post = current_user.tweets.new(params[:tweet])
    @posts = Tweet.where("(post_box IS NULL or post_box = 'post') and receiver_id IS NULL ").order("created_at Desc").paginate :page => params[:page], :per_page => 10
    respond_to do |format|
      format.html {render :partial => "index", :layout => false if request.xhr?}
      format.js {render :partial => "index", :layout => false if request.xhr?}
    end
  end

  def show
    @user = User.find(params[:id])
    @post = @user.tweets.new(params[:tweet])
    @header = params[:post].present? ? "#{params[:post].capitalize}" : " "
    if @header == 'Reply'
      @posts = Tweet.where("(user_id = '#{@user.id}' or receiver_id = '#{@user.id}') and reply = #{true}").order("created_at Desc").paginate :page => params[:page], :per_page => 10
    else
      @posts = Tweet.where("(user_id = '#{@user.id}' or receiver_id = '#{@user.id}') and (post_box IS NULL or post_box = 'post')").order("created_at Desc").paginate :page => params[:page], :per_page => 10
    end
    respond_to do |format|
      format.html {render :partial => "show", :layout => false if request.xhr?}
      format.js 
    end
  end

  def search
    @user = User.find_by_username(params[:query])
    if @user.present?
      @post = @user.tweets.new(params[:tweet])
      @posts = Tweet.where("user_id = '#{@user.id}' and reply IS NULL").order("created_at Desc").paginate :page => params[:index_page], :per_page => 10
      render :action => 'show'
    else
      flash[:error] = "Search not Found."
      redirect_to profiles_path
    end
  end

  def conversation
    @post = Tweet.find(params[:id])
    if @post.tweet_id == nil
      @posts = Tweet.where("tweet_id = '#{params[:id]}'").order("created_at Asc")
    else
      @posts = Tweet.where("tweet_id = '#{@post.id}' or tweet_id = '#{@post.tweet_id}'").order("created_at Asc")
    end
    render :layout => false
  end

  def edit
    @user = User.find(params[:id])
    if @user.id != current_user.id
      flash[:error] = 'Access Denied.'
      redirect_to profile_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully Updated your Profile details."
      redirect_to profile_path(@user)
    else
      flash[:error] = "Failed to Update your Profile details."
      render :action => 'edit'
    end
  end

  def profile_summary
    @user = User.find(params[:id])
    @posts = @user.tweets.paginate :page => params[:index_page], :per_page => 3
    render :layout => false
  end

  def edit_password

  end

  def update_password
    current_user.errors.add(:password, "is required") if params[:user].nil? or params[:user][:password].to_s.blank?
    if current_user.errors.empty? and current_user.update_with_password(params[:user])
      sign_in(:user, current_user, :bypass => true)
      flash[:notice] = 'Your password changed successfully.'
      redirect_to edit_password_profiles_path
    else
      flash[:error] = 'Password changing failed.'
      render :action => "edit_password"
    end
  end

  def followers
    @user = User.find(params[:id])
    @post = @user.tweets.new(params[:tweet])
    @users = User.where("confirmation_token IS NULL and id != '#{@user.id}'")
    @followers = @user.received_follows.where("status = #{true}")
  end

  def following
    @users = User.where("confirmation_token IS NULL and id != '#{current_user.id}'")
    @user = User.find(params[:id])
    @post = @user.tweets.new(params[:tweet])
    @followers = Follow.where("status = #{true} and user_id = #{@user.id}")
  end

  def compose_message
    if params[:tweet][:body].blank?
      render :update do |page|
        page.alert("Can't be blank.")
      end
    else
      @tweet = Tweet.new(params[:tweet])
      @tweet.user_id = current_user.id
      body = params[:tweet][:body].split(' ')[0]
      @user = User.find_by_username(body)
      @tweet.receiver_id = @user.present? ? @user.id : nil
      if @tweet.save
        render :update do |page|
          page.reload
        end
      else
        if remotipart_submitted?
          render :update do |page|
            page.alert('Uploading file is not correct format.')
          end
        end
      end
    end
  end

  def conversation_message
    @user = current_user
    @post = Tweet.find(params[:id])
    @posts = Tweet.order("created_at Desc").paginate :page => params[:page], :per_page => 10
    @post = Tweet.new(params[:tweet])
    @post.user_id = current_user.id
    @post.tweet_id = params[:id]
    body = params[:tweet][:body].split(' ')[0]
    @user = User.find_by_username(body)
    @post.receiver_id = @user.present? ? @user.id : nil
    @post.reply = true
    if @post.save
      render :update do |page|
        page.redirect_to profiles_path
      end
    else
      render :update do |page|
        page.alert("Conversation con't be blank.")
      end
    end
  end

  def new_compose
    @post = current_user.tweets.new(params[:tweet])
    render :layout => false
  end

  def new_compose_message
    if params[:tweet][:body].blank?
      render :update do |page|
        page.alert("Can't be blank.")
      end
    else
      @tweet = Tweet.new(params[:tweet])
      @tweet.user_id = current_user.id
      body = params[:tweet][:body].split(' ')[0]
      @user = User.find_by_username(body)
      @tweet.receiver_id = @user.present? ? @user.id : nil
      if @tweet.save
        render :update do |page|
          page.reload
        end
      else
        if remotipart_submitted?
          render :update do |page|
            page.alert('Uploading file is not correct format.')
          end
        end
      end
    end
  end

  def switch_theme
    @user = User.find(params[:id])
    @user.update_attribute(:theme, params[:url])
    render :update do |page|
    end
  end


  def post
    @user = User.find(params[:id])
    @post = Tweet.new(params[:tweet])
    render :layout => false
  end

  def create_post
    @user = User.find(params[:id])
    @post = Tweet.new(params[:tweet])
    @post.user_id = current_user.id
    @post.receiver_id = @user.id
    if @post.save
      render :update do |page|
        flash[:notice] = "Successfully Posted."
        page.reload
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def report
    @user = User.find(params[:id])
    @report = Report.new(params[:report])
    render :layout => false
  end

  def report_post
    @user = User.find(params[:id])
    @report = Report.new(params[:report])
    @report.user_id = current_user.id
    @report.receiver_id = @user.id
    if @report.save
      render :update do |page|
        flash[:notice] = "Successfully Reported."
        page.reload
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end
end
