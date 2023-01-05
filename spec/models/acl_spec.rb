# == Schema Information
#
# Table name: acls
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  resource_id :bigint
#  role_id     :bigint
#

require 'rails_helper'

RSpec.describe Acl, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
