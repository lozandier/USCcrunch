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
    #@graph = open_flash_chart_object(750,400,"/classes/#{@user.id}/graph")
    @graphs = open_flash_chart_object(750,300,"/classes/#{@user.id}/graph_code")
  end

  def graph
    @user = User.find(params[:id])
    bar_v = []
    title = Title.new("No Of Students")
    bar = BarGlass.new
    year = Time.now.year
    i = Time.now.strftime("%m").to_i
    y_range = []
    (1..31).each do |j|
      xx = "#{year}-#{i}-#{j}".to_time
      y= User.where("role = 'student' and reset_password_token IS NULL and users.created_at LIKE '#{xx.to_datetime.strftime('%Y-%m-%d')}%'").count
      bar_values = BarValue.new(y);
      y_range << y
      bar_v << bar_values
    end
    bar.set_values(bar_v)
    x = XAxis.new
    days = Time.days_in_month(i)
    x.labels =  (1..days).to_a.collect(&:to_s)
    range = y_range.sort().last > 15 ? y_range.sort().last : 15
    y_ax = YAxis.new
    y_ax.set_range(0,range,1)
    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.bg_colour='#F9F9F9'
    chart.add_element(bar)
    chart.x_axis = x
    chart.y_axis = y_ax
    render :text => chart
  end

  def graph_code
    @user = User.find(params[:id])
    # based on this example - http://teethgrinder.co.uk/open-flash-chart-2/pie-chart.php
    title = Title.new("Students And Posts")
    @total_received_people = User.where("id = #{@user.id} and role = 'student'").count
    @total_received_post = Tweet.where("user_id = #{@user.id} and reply IS NULL").count

    pie = Pie.new
    pie.start_angle = 90
    pie.animate = true
    pie.tooltip = '#val# of #total#<br>#percent# of 100%'
    pie.colours = ["#d01f3c","#d01fff"]
    pie.values  = [PieValue.new(@total_received_people,"Students"),PieValue.new(@total_received_post,"Posts")] #[@total_non_replied_people, @total_replied_people]

    chart = OpenFlashChart.new
    chart.title = title
    chart.bg_colour='#F9F9F9'
    chart.add_element(pie)

    chart.x_axis = nil

    render :text => chart.to_s
  end

  def edit
    @user = User.find(params[:id])
    if @user.id != current_user.id
      flash[:error] = 'Access Denied.'
      redirect_to class_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully Updated your Class details."
      redirect_to class_path(@user)
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
