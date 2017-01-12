# == error handler
#
#
# Author: Yuji Mise
# Copyright 2015  
#
module Grape
  module Support
    module API
      module ErrorHandler
        extend ActiveSupport::Concern

        included do

          rescue_from ActiveRecord::RecordNotFound do |exception|
            Grape::Support.logger.error "#{exception.class} (#{exception.message})"
            rack_response({ 'errors' => ['404 Not found'] }.to_json, 404)
          end

          rescue_from ActiveRecord::RecordInvalid do |exception|
            Grape::Support.logger.error "#{exception.class} (#{exception.message})"
            rack_response({ 'errors' => [exception.message] }.to_json, 400)
          end

          rescue_from Grape::Exceptions::ValidationErrors do |exception|
            message = "#{exception.class} (#{exception.message})"
            Grape::Support.logger.error message
            rack_response( {'errors' => [exception.message] }.to_json, 400)
          end

          rescue_from :all do |exception|
            trace = exception.backtrace

            message = "\n#{exception.class} (#{exception.message}):\n"
            message << exception.annoted_source_code.to_s if exception.respond_to?(:annoted_source_code)
            message << "  " << trace.join("\n  ")

            Grape::Support.logger.error message
            message = "#{exception.class} (#{exception.message})"
            rack_response( {'errors' => ['500 Internal Server Error'] }, 500)
          end

        end

      end
    end
  end
end
