class ClassesController < ApplicationController
  before_filter :is_login?
  layout :get_layout

  def index
    
  end

  def show
    @user = User.find(params[:id])
    @header = "Posts"
    sql_query = "select * from tweets a where (id in (select max(id) from tweets b where a.user_id = b.user_id ))"
    @posts = Tweet.paginate_by_sql [sql_query], :per_page => 20, :page => params[:page]
    respond_to do |format|
      format.html {render :partial => "show", :layout => false if request.xhr?}
      format.js {render :partial => "show", :layout => false if request.xhr?}
    end
  end
end
