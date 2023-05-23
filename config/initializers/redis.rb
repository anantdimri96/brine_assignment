# frozen_string_literal: true

require 'redis'

# Set the Redis server URL
redis_url = ENV.fetch('REDIS_URL_CACHING', 'redis://localhost:6379/1')

# Create a Redis client instance
REDIS = Redis.new(url: redis_url)
