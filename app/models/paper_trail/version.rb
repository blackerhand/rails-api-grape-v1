# == Schema Information
#
# Table name: versions
#
#  id             :bigint           not null, primary key
#  item_type      :string(191)      not null
#  item_id        :bigint           not null
#  event          :string(255)      not null
#  whodunnit      :string(255)
#  object         :text(4294967295)
#  created_at     :datetime
#  object_changes :text(4294967295)
#

module PaperTrail
  class Version < ActiveRecord::Base
    include PaperTrail::VersionConcern

    belongs_to :user, foreign_key: 'whodunnit', optional: true

    def filed_cn(field_en)
      field_en = field_en.to_s

      case field_en
      when 'id'
        'ID'
      when 'created_at'
        '创建时间'
      when 'updated_at'
        '修改时间'
      else
        I18n.t(field_en, scope: "activerecord.attributes.#{item_type.to_s.underscore}")
      end
    end

    def filed_format(key, val)
      key = key.to_s
      return val if val.blank?

      if val.is_a?(Time)
        val.strftime('%F %T')
      elsif key == 'state' && item_type.safe_constantize.try(:respond_to?, :state_name)
        item_type.safe_constantize.state_name(val) || val
      elsif item_type.safe_constantize.try(:defined_enums).try(:keys).try(:include?, key) && val.is_a?(Numeric)
        item_type.safe_constantize.defined_enums.keys[key].select { |_zh, num| val == num }.first.try(:first) || val
      elsif key =~ /user_id/
        User.find_by(id: val).try(:open_name) || val
      else
        val
      end
    end

    def changeset_cn
      changeset.each_with_object({}) do |change, cn|
        cn[filed_cn(change[0])] = [filed_format(change[0], change[1][0]), filed_format(change[0], change[1][1])]
      end
    end
  end
end
