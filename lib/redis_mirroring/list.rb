# frozen_string_literal: true

module RedisMirroring
  module List
    def mirroring_paginate(key, page:, per_page: 20)
      page = page.to_i.zero? ? 1 : page.to_i
      start_index = (page - 1) * per_page
      end_index = start_index + per_page - 1
      instances = range(key, start_index, end_index)
      if instances.is_a?(Array)
        total_count = length(key)
        total_page = (total_count / per_page) + 1
        offset_value = start_index

        ActsAsPaginatable.new(instances,
                                total_pages:   total_page,
                                total_count:   total_count,
                                offset_value:  offset_value,
                                limit_value:   per_page,
                                current_page:  page,
                                is_first_page: (page == 1),
                                is_last_page:  (total_page == page)
                             )
      else
        instances.page(page).per(per_page)
      end
    end

    def values(key)
      vals = range(key, 0, -1)
      vals.nil? ? [] : vals
    end

    def range(key, start_index, end_index)
      vals = redis.lrange(key, start_index, end_index).map{|v| Marshal.load(v) }
      raise RedisDataNotFound if vals.blank?
      vals
    rescue => ex
      Rails.logger.error("#{ex.class.name} : #{mirroring_key} => #{key}")
      ar_search_by_key(key)
    end

    def length(key)
      redis.llen(key)
      raise RedisDataNotFound if vals.blank?
    rescue => ex
      Rails.logger.error("#{ex.class.name} : #{mirroring_key} => #{key}")
      ar_search_by_key(key).count
    end

    def delete(key)
      redis.del(key)
    end
  end
end
