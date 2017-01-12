require 'rails/all'
require 'grape'
require 'her'
require 'request_store'
require_relative "support/version"
require_relative "support/grape_generator"
require_relative "support/array_string_mapper"
require_relative "support/json_field_mapper"
require_relative "support/date_converter"
require_relative "support/distribute_lock"
require_relative "support/interface"
require_relative "support/enum"
require_relative "support/active_record_union"

require_relative "support/api/error_handler"
require_relative "support/api/base_entity"
require_relative "support/api/base"
require_relative "support/api/request_store_key"
require_relative "support/api/helpers"

# initialization.
#
#  Grape::Support.setup do |config|
#    config.distribute_lock_client = {
#      host: '192.168.0.2',
#      port: 6379,
#      database: 1
#    }
#  end
#
module Grape
  module Support

    def self.setup
      yield self
    end

    def self.distribute_lock_client=(config)
      @@distribute_lock_client ||= Redic.new "redis://#{config['host']}:#{config['port']}/#{config['database']}"
    end

    def self.distribute_lock_client
      @@distribute_lock_client
    end

    def self.logger=(logger)
      @@logger ||= logger
    end

    def self.logger
      @@logger || Rails.logger
    end

    def self.auth_api_host_url
      @@auth_api_host_url
    end

    def self.auth_api_host_url=(auth_api_host_url)
      @@auth_api_host_url = auth_api_host_url
      require_relative "support/api/token_authentication"
      require_relative "support/api/auth_api"
      require_relative "support/api/scope"
      require_relative "support/api/session"
    end

    def self.dashboard_api_host_url
      @@dashboard_api_host_url
    end

    def self.dashboard_api_host_url=(dashboard_api_host_url)
      @@dashboard_api_host_url = dashboard_api_host_url
      require_relative "support/api/token_authentication"
      require_relative "support/api/dashboard_api"
      require_relative "support/api/user"
    end

    def self.manager_namescope
      'manager'
    end

  end
end
