# == Schema Information
#
# Table name: users
#
#  id                   :bigint           not null, primary key
#  code                 :string(6)
#  disabled_at          :datetime
#  email                :string(100)
#  favorite_posts_count :integer          default(0)
#  like_posts_count     :integer          default(0)
#  nickname             :string(20)
#  password_digest      :string(255)
#  type                 :string(255)
#  unlike_posts_count   :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  created_user_id      :bigint
#  updated_user_id      :bigint
#

class Admin < User
end
