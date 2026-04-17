class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  after_create_commit { broadcast_replace_to("likes", target: "#{self.likeable_type.downcase}_#{self.likeable_id}_likes_counter", partial: "likes/counter", locals: { likeable: self.likeable }) }
  after_destroy_commit { broadcast_replace_to("likes", target: "#{self.likeable_type.downcase}_#{self.likeable_id}_likes_counter", partial: "likes/counter", locals: { likeable: self.likeable }) }
end
