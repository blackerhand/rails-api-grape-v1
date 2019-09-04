# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  title       :string(255)
#  desc        :text(65535)
#  user_id     :integer
#  disabled_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Post < ApplicationRecord
  include Disable
  acts_as_taggable
  resourcify

  has_many :items
  validates :title, presence: true, uniqueness: true
end
