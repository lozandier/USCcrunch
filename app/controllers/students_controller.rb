class StudentsController < ApplicationController
  layout :get_school_layout
  def new
    @school = SchoolAdmin.find(params[:school_id])
    @student = @school.students.new
  end

  def create
    @school = SchoolAdmin.find(params[:school_id])
    @student = @school.students.new(params[:student])
    if @student.save
      flash[:notice] = "Sccessfully Send invitation to student"
      UserMailer.sent_student_invitation(@school,@student).deliver
      redirect_to school_path(@school)
    else
      flash[:error] = "Failed to Send Invitation"
      render :action => 'new'
    end
  end
end
