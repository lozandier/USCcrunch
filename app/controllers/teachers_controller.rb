class TeachersController < ApplicationController
  layout :get_layout

  def new
    @school = School.find(params[:school_id])
    @teacher = @school.teachers.new
  end

  def create
    @school = School.find(params[:school_id])
    @teacher = @school.teachers.new(params[:teacher])
    if @teacher.save
      flash[:notice] = "Success"
      UserMailer.sent_teacher_invitation(@teacher,@student).deliver
      redirect_to school_path(@school)
    else
      render :action => "new"
    end
  end
end
