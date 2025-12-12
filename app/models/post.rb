class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  validates :title, presence: true, length: { minimum: 5 }
  mount_uploader :cover, PostCoverUploader
  
  acts_as_taggable_on :tags
  acts_as_taggable_on :categories
end
