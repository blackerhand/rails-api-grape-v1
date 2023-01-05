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

require 'rails_helper'

RSpec.describe Resource, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
