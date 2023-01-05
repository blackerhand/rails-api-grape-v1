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

FactoryBot.define do
  factory :acl do
    
  end
end
