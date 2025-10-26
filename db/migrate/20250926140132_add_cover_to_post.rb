class AddCoverToPost < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :cover, :string
  end
end
