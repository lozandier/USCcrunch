class TweetsController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @tweet = @user.tweets.new
    render :layout => false
  end

  def create
    @user = User.find(params[:user_id])
    @tweet = @user.tweets.new(params[:tweet])
    @tweet.user_id = current_user.id
    @tweet.receiver_id = @user.id
    if @tweet.save
      render :update do |page|
        flash[:notice] = "Successfully twitted this user."
        page.redirect_to profiles_path
      end
    else
      if remotipart_submitted?
        respond_to do |format|
          format.js
        end
      end
    end
  end

  def show
    
  end

  def destroy
    @user = User.find(params[:user_id])
    @tweet = @user.tweets.find(params[:id])
    if  @tweet.destroy
      respond_to do |format|
        format.js{@tweet}
      end
    end
  end
end
