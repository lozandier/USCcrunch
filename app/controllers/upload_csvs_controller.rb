require 'csv'
class UploadCsvsController < ApplicationController

  def upload_csv
    @school = School.find(params[:school_id])
    if params[:student]
      if params[:student][:csv]
        CSV.parse(params[:student][:csv].read) do |row|

          row = row.collect{|s| s.gsub("\"", "")}
          # row = row[0].to_s.split("\t").collect(&:strip)

          Student.create({
              :school_id => @school.id,
              :email => row[0],
              :first_name => row[1],
              :name => row[2],
              :date_of_birth => row[3],
            })
        end

        flash[:notice] = "Uploading completed."
        redirect_to school_path(@school)
      end
    else
      render :action => "/schools/#{@school.id}/students/new"
    end
  end

end
