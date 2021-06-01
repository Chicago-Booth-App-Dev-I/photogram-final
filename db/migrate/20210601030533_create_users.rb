class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.integer :likes_count
      t.integer :comments_count
      t.string :password_digest
      t.integer :sent_follow_requests_count
      t.integer :received_follow_requests_count
      t.integer :own_photos_count
      t.boolean :private

      t.timestamps
    end
  end
end
