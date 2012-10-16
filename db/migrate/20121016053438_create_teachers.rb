class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.integer :school_id
      t.string :email
      t.string :name
      t.date :date_of_birth
      t.timestamps
    end
  end
end
