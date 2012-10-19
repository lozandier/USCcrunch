class AddFirstNameToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :first_name, :string
    add_column :schools, :last_name, :string
  end
end
