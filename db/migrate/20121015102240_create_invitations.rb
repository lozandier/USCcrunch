class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.text :body
      t.string :email
      t.string :username

      t.timestamps
    end
  end
end
