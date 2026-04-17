class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  has_many :likes, as: :likeable

  validates :title, presence: true, length: { minimum: 5 }
  mount_uploader :cover, PostCoverUploader

  # has_rich_text :body
  
  acts_as_taggable_on :tags
  acts_as_taggable_on :categories
end
