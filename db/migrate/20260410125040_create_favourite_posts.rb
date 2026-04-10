class CreateFavouritePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :favourite_posts do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
  end
end
