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

  def repost
    @tweet = Tweet.find(params[:user_id])
    @repost = Tweet.new(:user_id => @tweet.user_id, :receiver_id => @tweet.receiver_id, :body => @tweet.body)
    if @repost.save
      render :update do |page|
        flash[:notice] = "Successfully Reposted."
        page.reload
      end
    else
      render :update do |page|
        flash[:error] = "Failed to Repost."
        page.reload
      end
    end
  end

  def show
    
  end

  def favourite
    @tweet = Tweet.find(params[:user_id])
    @favourite = Favorite.new(:user_id => current_user.id,:tweet_id=>@tweet.id,:status => true).save
    render :update do |page|
      page.alert('Marked as Favourites')
      page.reload
    end
  end

  def update_favourite
    @tweet = Tweet.find(params[:user_id])
    @favourite = @tweet.favorite.update_attribute(:status, false)
    render :update do |page|
      page.alert('Unmarked as Favourites')
      page.reload
    end
  end

  def update_mark_favourite
    @tweet = Tweet.find(params[:user_id])
    @favourite = @tweet.favorite.update_attribute(:status, true)
    render :update do |page|
      page.alert('marked as Favourites')
      page.reload
    end
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
