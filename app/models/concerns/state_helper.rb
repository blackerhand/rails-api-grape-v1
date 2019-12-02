module StateHelper
  extend ActiveSupport::Concern

  included do
    def state_name
      I18n.t(state, scope: self.class.state_i18n_keys)
    end

    def state_index
      state_before_type_cast
    end

    def offline_time_display
      offline_time if state == 'state_offline'
    end

    def available_state_names
      glass = self.class

      aasm.events.map do |e|
        glass.state_name(e.name.to_s.gsub('do_', ''))
      end
    end
  end

  module ClassMethods
    def state_i18n_keys
      "activerecord.attributes.#{to_s.underscore}.state_enum"
    end

    def state_zh
      i18ns = I18n.t(state_i18n_keys)

      states.each_with_object({}) do |state, zh|
        en_key     = state[0].to_sym
        zh_key     = i18ns[en_key].to_sym
        zh[zh_key] = state[1]
      end
    end

    def state_en(state_cn)
      I18n.t(state_i18n_keys).select { |_en, zh| zh == state_cn.to_s }.first.first
    end

    def state_en_for_index(state_index)
      states.select { |_k, v| v == state_index }.keys.first
    end

    def state_name(state_en)
      I18n.t(state_en, scope: state_i18n_keys)
    end
  end
end
