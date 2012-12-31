class NotificationsController < ApplicationController
  before_filter :is_login?
  layout :get_layout

  def index
    sql_query = "select * from tweets a where (id in (select max(id) from tweets b where a.receiver_id = b.receiver_id and b.body like '@%%' and a.receiver_id != #{current_user.id})) order by a.created_at desc"
    @posts = Tweet.paginate_by_sql [sql_query], :per_page => 20, :page => params[:page]
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
