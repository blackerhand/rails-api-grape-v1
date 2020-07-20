# == Schema Information
#
# Table name: posts
#
#  id                :bigint           not null, primary key
#  desc(说明)        :text(65535)
#  disabled_at       :datetime
#  favorites_count   :integer          default(0)
#  likes_count       :integer          default(0)
#  title(标题)       :string(255)
#  unlikes_count     :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  created_user_id   :bigint
#  updated_user_id   :bigint
#  user_id           :integer
#

class Post < ApplicationRecord
  include Disable

  acts_as_taggable
  resourcify
end
