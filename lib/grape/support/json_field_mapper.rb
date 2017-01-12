# == json field mapper
#
#
# Author: Yuji Mise
# Copyright 2015  
#
module Grape
  module Support
    module JsonFieldMapper
      extend ActiveSupport::Concern

      module ClassMethods

        def mapping_json_field(column_name: )

          define_method("#{column_name.to_s}=") do |value|
            return write_attribute(column_name, nil) if value.blank?
            write_attribute(column_name, ActiveSupport::JSON.encode(value))
          end

          define_method("#{column_name.to_s}") do
            value = read_attribute(column_name)
            return if value.blank?
            ActiveSupport::JSON.decode(value)
          end

        end

      end

    end
  end
end
