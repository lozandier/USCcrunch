class ClassesController < ApplicationController
  before_filter :is_login?
  layout :get_layout

  def index
    
  end

  def show
    @user = User.find(params[:id])
    @post = @user.tweets.new(params[:tweet])
    sql_query = "select * from tweets a where (a.user_id in (select  user_id from tweets where receiver_id=#{current_user.id})) and (id in (select max(id) from tweets b where a.user_id = b.user_id and a.receiver_id = b.receiver_id)) and  a.receiver_id = #{current_user.id} order by a.created_at desc"
    @posts = Tweet.paginate_by_sql [sql_query], :per_page => 10, :page => params[:page]
    respond_to do |format|
      format.html {render :partial => "show", :layout => false if request.xhr?}
      format.js {render :partial => "show", :layout => false if request.xhr?}
    end
  end
end
