# == base api
#
#
# Author: Yuji Mise
# Copyright 2015  
#
module Grape
  module Support
    module API
      module Base
        extend ActiveSupport::Concern

        included do
          format :json
          default_format :json
          content_type :json, "application/json; charset=UTF-8"

          include Grape::Support::API::ErrorHandler

          helpers Grape::Support::API::Helpers
          helpers Grape::Support::API::SharedParams

        end

      end
    end
  end
end
