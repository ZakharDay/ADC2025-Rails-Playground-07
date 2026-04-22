class AddShareImageToPost < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :share_image, :string
  end
end
