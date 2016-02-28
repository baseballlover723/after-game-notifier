class CreateUsernames < ActiveRecord::Migration
  def change
    create_table :usernames do |t|
      t.string :username
      t.string :region

      t.timestamps null: false
    end
  end
end
