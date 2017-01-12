# == base entity
#
#
# Author: Yuji Mise
# Copyright 2015  
#
module Grape
  module Support
    module API
      class BaseEntity < Grape::Entity

        format_with(:response_format_date) { |dt| dt.strftime "%Y-%m-%d %H:%M:%S" }

        def self.inherited(child)
          child.root 'items'
        end

      end
    end
  end
end
