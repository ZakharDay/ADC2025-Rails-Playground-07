class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :comments

  has_many :favourite_posts
  has_many :favourites, through: :favourite_posts, class_name: "Post", foreign_key: "post_id"

  # has_many :fill_colors
  # has_many :colors, through: :fill_colors
  # has_many :forks, class_name: "Swatch", foreign_key: "origin_id"
  # belongs_to :origin, class_name: "Swatch", optional: true
end
