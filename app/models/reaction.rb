class Reaction < ApplicationRecord
  enum :kind, {
    red: "red",
    green: "green",
    blue: "blue",
    orange: "orange",
    yellow: "yellow",
    pink: "pink"
  }

  belongs_to :post
  belongs_to :user

  after_create_commit { broadcast_replace_to("reactions", target: "post_#{post.id}_reactions_counter", partial: "reactions/counter", locals: { post: post }) }
  after_destroy_commit { broadcast_replace_to("reactions", target: "post_#{post.id}_reactions_counter", partial: "reactions/counter", locals: { post: post }) }
end
