class AddCounterForPostUserFavorite < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :favorites_count, :integer, default: 0
    add_column :users, :favorite_posts_count, :integer, default: 0

    add_column :posts, :likes_count, :integer, default: 0
    add_column :users, :like_posts_count, :integer, default: 0

    add_column :posts, :unlikes_count, :integer, default: 0
    add_column :users, :unlike_posts_count, :integer, default: 0
  end
end
