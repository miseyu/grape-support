# == 分散ロック
#
#
# Author: Yuji Mise
# Copyright 2014  
#
module Grape
  module Support
    module DistributeLock

      class LockError < StandardError; end

      def lock_for_update(key, timeout: 60, max_attempts: 10)
        return unless lock(key, timeout, max_attempts)
        yield if block_given?
      ensure
        unlock(key)
      end

      module_function def lock(key, timeout, max_attempts)
        current_lock_key = generate_key(key)
        expiration_value = lock_expiration(timeout)
        attempt_counter = 0
        loop do
          break if attempt_counter >= max_attempts
          return true if redis_client.call('setnx', current_lock_key, expiration_value) == 1
          current_lock = redis_client.call('get', current_lock_key)
          if (current_lock.to_s.split('-').first.to_i) < Time.now.to_i
            compare_value = redis_client.call('getset', current_lock_key, expiration_value)
            return true if compare_value == current_lock
          end
          attempt_counter += 1
          sleep 1 if attempt_counter < max_attempts
        end
        raise LockError.new("Unable to acquire lock for #{key}.")
      end

      module_function def unlock(key)
        current_lock_key = generate_key(key)
        lock_value = redis_client.call('get', current_lock_key)
        return unless lock_value
        lock_timeout, lock_process, lock_thread = lock_value.split('-')
        if (lock_timeout.to_i > Time.now.to_i) && (lock_process.to_i == Process.pid) && lock_thread.to_i == Thread.current.object_id
          redis_client.call('del', current_lock_key)
        end
      end

      module_function def redis_client
        @redis_client ||= Grape::Support.distribute_lock_client
      end

      module_function def lock_expiration(timeout)
        "#{Time.now.to_i + timeout + 1}-#{Process.pid}-#{Thread.current.object_id}"
      end

      module_function def generate_key(regist_key)
        "Grape::Support::DistributeLock::#{regist_key}"
      end

    end
  end
end
