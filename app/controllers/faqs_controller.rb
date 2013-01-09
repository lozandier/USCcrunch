class FaqsController < ApplicationController
  before_filter :is_login?
  layout :get_layout

  def index
    @user = User.find(params[:class_id])
    1.times{@user.faqs.new}
  end

  def upload_doc
    @user = User.find(params[:class_id])
    @user.attributes = params[:user]
    reject = @user.faqs.inject(true){|truthiness, n| !!(truthiness && n.marked_for_destruction?) }
    if !reject and @user.save
      flash[:notice] = "Successfully given document names"
      redirect_to class_faqs_path(@user)
    else
      1.times{@user.faqs.build}
      flash[:error] = "Document Names given failed"
      render :action => "index"
    end
  end
end
