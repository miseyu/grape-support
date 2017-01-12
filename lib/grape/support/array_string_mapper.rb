# == array string mapper
#
# = Usage:
#
#   mapping_array_string column_name: :available_features, allow_values: [:hoge, :fuga], data_format: :symbol
#
# Author: Yuji Mise
#
module Grape
  module Support
    module ArrayStringMapper
      extend ActiveSupport::Concern

      included do
      end

      module ClassMethods

        def mapping_array_string(column_name: , allow_values: nil, data_format: :string)

          convert_string_data = -> data, data_format do
            case data_format
            when :string, :symbol then data.to_s
            when :json
              ActiveSupport::JSON.encode data
            end
          end

          parse_format_data = -> data, data_format do
            case data_format
            when :string then data.to_s
            when :symbol then data.to_s.to_sym
            when :json
              ActiveSupport::JSON.decode data
            end
          end

          define_method("#{column_name.to_s[0..-2]}=") do |value|
            if allow_values.present?
              raise ArgumentError, 'argument invalid error. feature is invalid' unless allow_values.include?(value)
            end
            datas = try(column_name) || []
            datas << value
            datas.uniq!
            instance_variable_set("@#{column_name.to_s}".to_sym, datas)
            write_attribute(
              column_name,
              if datas.size == 1
                convert_string_data(datas.first)
              else
                datas.reduce { |a, b| "#{convert_string_data(a, data_format)},#{convert_string_data(b, data_format)}" }
              end
            )
          end

          define_method("#{column_name.to_s}=") do |values|
            values = values.delete_if { |detail| detail.blank? }
            if values.blank?
              instance_variable_set("@#{column_name.to_s}".to_sym, nil)
              write_attribute(column_name, nil)
            else
              raise ArgumentError, 'argument implement respond to enumerable' unless values.respond_to?(:each)
              if allow_values.present?
                raise ArgumentError, 'argument invalid error. feature is invalid' unless values.any? { |value| allow_values.include?(value) }
              end
              instance_variable_set("@#{column_name.to_s}".to_sym, values)
              write_attribute(column_name, values.reduce { |a, b| "#{convert_string_data(a, data_format)},#{convert_string_data(b, data_format)}" })
            end
          end

          define_method("#{column_name.to_s}") do
            unless instance_variable_defined?("@#{column_name.to_s}".to_sym)
              instance_variable_set("@#{column_name.to_s}".to_sym,
                if read_attribute(column_name).blank?
                  []
                else
                  read_attribute(column_name).split(',').map { |data| parse_format_data(data, data_format) }
                end
              )
            end
            instance_variable_get("@#{column_name.to_s}".to_sym)
          end

          define_method("#{column_name.to_s[0..-2]}?") do |value|
            try(column_name).include? value
          end

        end
      end
    end
  end
end
