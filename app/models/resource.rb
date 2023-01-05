# == Schema Information
#
# Table name: resources
#
#  id          :bigint           not null, primary key
#  ancestry    :string(255)
#  description :string(255)
#  name        :string(255)      not null
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_resources_on_ancestry  (ancestry)
#

class Resource < ApplicationRecord
  has_ancestry
end
