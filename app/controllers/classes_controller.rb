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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      @user.update_attribute(:username,'@'+@user.username)
      flash[:notice] = "Successfully Updated your Class details."
      redirect_to edit_class_path(@user)
    else
      flash[:error] = "Failed to Update your Class details."
      render :action => 'edit'
    end
  end

  def roster
    @user = User.find(params[:id])
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
