class AddSchoolAdminIdToStudents < ActiveRecord::Migration
  def change
    add_column :students, :school_admin_id, :integer
  end
end
