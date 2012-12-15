class HomeController < ApplicationController

  def index
    
  end

  def new_user1
    @user = User.find(params[:id])
    sql_query = "select * from tweets a where (id in (select max(id) from tweets b where a.user_id = b.user_id )) order by a.created_at desc"
    @posts = Tweet.paginate_by_sql [sql_query], :per_page => 10, :page => params[:page]
    render :layout => false
  end

  def new_user2
    @user = User.find(params[:id])
    sql_query = "select * from tweets a where (id in (select max(id) from tweets b where a.user_id = b.user_id )) order by a.created_at desc"
    @posts = Tweet.paginate_by_sql [sql_query], :per_page => 10, :page => params[:page]
    render :layout => false
  end

  def update_new_user2
    @user = User.find(params[:id])
    sql_query = "select * from tweets a where (id in (select max(id) from tweets b where a.user_id = b.user_id )) order by a.created_at desc"
    @posts = Tweet.paginate_by_sql [sql_query], :per_page => 10, :page => params[:page]
    if @user.update_attributes(params[:user])
      redirect_to profiles_path
    else
      flash[:error] = "Failed to Update your Profile details."
      render :action => 'new_user2', :layout => false
    end

  end

  def school_login

  end

  def about
  end

  def terms_of_service
    
  end

  def privacy_policy
    
  end

end
