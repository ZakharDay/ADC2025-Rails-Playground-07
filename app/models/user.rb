class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :comments

  has_many :favourite_posts
  has_many :favourites, through: :favourite_posts, source: :post

  has_many :likes, as: :likeable
end
