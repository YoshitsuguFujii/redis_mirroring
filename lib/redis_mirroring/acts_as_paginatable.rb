# frozen_string_literal: true

module RedisMirroring
  class ActsAsPaginatable < Array
    PAGINATE_METHODS = %i[total_pages total_count offset_value limit_value current_page is_first_page is_last_page].freeze

    PAGINATE_METHODS.each do |accessor|
      define_method accessor do
        instance_variable_get("@#{accessor}".to_sym)
      end
    end

    def initialize(original_array = [], options )
      PAGINATE_METHODS.each do |accessor|
        instance_variable_set("@#{accessor}".to_sym , options[accessor])
      end
      super(original_array || [])
    end

    def first_page?
      is_first_page
    end

    def last_page?
      is_last_page
    end
  end
end
