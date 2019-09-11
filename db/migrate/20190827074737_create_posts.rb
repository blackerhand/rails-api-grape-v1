class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title, comment: '标题'
      t.text :desc, comment: '说明'
      t.integer :user_id
      t.datetime :disabled_at

      t.timestamps
    end
  end
end
