# == union ext
#
#
# Author: Yuji Mise
# Copyright 2014
#
module Grape
  module Support
    module ActiveRecordUnion
      extend ActiveSupport::Concern

      module ClassMethods

        def union(*relations)
          sql = connection.unprepared_statement do
            '((' + relations.map { |r| r.to_sql }.join(') UNION (') + ')) AS ' + self.table_name
          end
          from sql
        end
      end
    end
  end
end
