class StudentsController < ApplicationController
  def new
    @school = School.find(params[:school_id])
    @student = @school.students.new
  end

  def create
    @school = School.find(params[:school_id])
    @student = @school.students.new(params[:student])
    if @student.save
      flash[:notice] = "Sccessfully Send invitation to student"
      UserMailer.sent_student_invitation(@school,@student).deliver
      redirect_to school_path(@school)
    else
      render :action => 'new'
    end
  end
end
