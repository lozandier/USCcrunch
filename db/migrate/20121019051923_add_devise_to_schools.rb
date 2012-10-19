class AddDeviseToSchools < ActiveRecord::Migration
  def change
    change_table(:schools) do |t|
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at

    end
    add_index :schools, :email,                :unique => true
    add_index :schools, :reset_password_token, :unique => true
  end
end
