class CreateUsernames < ActiveRecord::Migration
  def change
    create_table :usernames do |t|
      t.string :username
      t.string :stripped_username
      t.string :region
      t.string :user_id

      t.timestamps null: false
    end
  end
end
