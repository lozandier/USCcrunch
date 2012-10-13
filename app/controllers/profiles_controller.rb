class ProfilesController < ApplicationController
  before_filter :is_login?

  def index
    @users = User.where("confirmation_token IS NULL and id != '#{current_user.id}'")
    @tweets = Tweet.paginate :page => params[:index_page], :per_page => 10
  end

  def show
    @user = User.find(params[:id])
    @tweet = @user.tweets.new(params[:tweet])
    @tweets = Tweet.where("user_id = '#{@user.id}'").paginate :page => params[:index_page], :per_page => 10
  end

  def edit
    @user = User.find(params[:id])
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
    @tweets = @user.tweets.paginate :page => params[:index_page], :per_page => 3
    render :layout => false
  end

  def edit_password

  end

  def update_password
    current_user.errors.add(:password, "is required") if params[:user].nil? or params[:user][:password].to_s.blank?
    if current_user.errors.empty? and current_user.update_with_password(params[:user])
      sign_in(:user, current_user, :bypass => true)
      flash[:notice] = 'Your password changed successfully.'
    else
      flash[:error] = 'Password changing failed.'
    end
    render :action => "edit_password"
  end

  def followers
    @user = User.find(params[:id])
    @tweet = @user.tweets.new(params[:tweet])
    @users = User.where("confirmation_token IS NULL and id != '#{@user.id}'")
    @followers = @user.received_follows.where("status = #{true}")
  end

  def following
    @users = User.where("confirmation_token IS NULL and id != '#{current_user.id}'")
    @user = User.find(params[:id])
    @tweet = @user.tweets.new(params[:tweet])
    @followers = Follow.where("status = #{true} and user_id = #{@user.id}")
  end
end
