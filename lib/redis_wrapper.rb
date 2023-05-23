# frozen_string_literal: true

class RedisWrapper
  @redis = REDIS

  def self.set(key, value, expiration_seconds = nil)
    @redis.set(key, value)
    @redis.expire(key, expiration_seconds) if expiration_seconds
  end

  def self.get(key)
    @redis.get(key)
  end

  def self.delete(key)
    @redis.del(key)
  end

  def self.expire(key, seconds)
    @redis.expire(key, seconds)
  end

  def self.exists(key)
    @redis.exists(key)
  end
end
