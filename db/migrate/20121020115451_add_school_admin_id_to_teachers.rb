class AddSchoolAdminIdToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :school_admin_id, :integer
  end
end
