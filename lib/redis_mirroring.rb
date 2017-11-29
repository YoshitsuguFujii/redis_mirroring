require "redis_mirroring/version"
require 'active_support/dependencies/autoload'

module RedisMirroring
  extend ActiveSupport::Autoload

  autoload :ActsAsPaginatable
  autoload :List

  class RedisDataNotFound < StandardError; end


  if defined?(Rails)
    class Railtie < Rails::Railtie
      initializer 'redis-mirroring.active_record' do
        Rails.application.config.to_prepare do
          ActiveSupport.on_load :active_record do
            extend ClassMethods
          end
        end
      end
    end
  end

  module ClassMethods
    def mirroring(key: , order: nil, worker: nil)
      extend List

      @mirroring_key = key
      @mirroring_order = order

      after_save do
        if worker.present?
          worker.perform_async(user_id)
        else
          self.class.save_to_redis(user_id)
        end
      end
    end

    def redis
      return @redis if @redis.present?
      namespace = [Rails.application.class.parent_name, Rails.env, name].join ':'
      @redis = Redis::Namespace.new(namespace, redis: $redis)
    end

    def mirroring_key
      @mirroring_key
    end

    def save_to_redis(key)
      redis_values = ar_search_by_key(key)
      delete(key)
      redis.rpush(key, redis_values.map{|v| Marshal.dump(v) }) if redis_values.present?
    end

    def ar_search_by_key(key)
      instances = where(@mirroring_key => key)
      if @mirroring_order.present?
        instances = instances.order(@mirroring_order)
      end
      instances
    end
  end
end
