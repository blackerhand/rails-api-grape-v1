module Onlineable
  extend ActiveSupport::Concern

  included do
    include StateHelper
    include AASM

    def guard_online
      true
    end

    def guard_offline
      true
    end
  end

  module ClassMethods
    # rubocop:disable Metrics/MethodLength
    def onlineable(definitions)
      enum definitions
      enum_maps = definitions.delete(:state)

      class_eval do
        aasm(column: :state, enum: true) do
          static_enum_maps = enum_maps.except(:state_draft, :state_online, :state_offline)

          state :state_draft, initial: true # 暂存
          state :state_online # 已上架
          state :state_offline # 已下架

          static_enum_maps.each do |state_name, _state_index|
            state state_name

            event "do_#{state_name}".to_sym do
              transitions from: enum_maps.keys, to: state_name
            end
          end

          event :do_state_online do
            before do
              self.online_time = Time.current unless state == 'state_online'
            end

            transitions from: enum_maps.keys, to: :state_online, guard: :guard_online
          end

          event :do_state_offline do
            before do
              self.offline_time = Time.current unless state == 'state_offline'
            end

            transitions from: enum_maps.keys, to: :state_offline, guard: :guard_offline
          end

          event :do_state_draft do
            transitions from: %i[state_draft], to: :state_draft
          end
        end
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
