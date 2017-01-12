# == enum
#
#
# Author: Yuji Mise
# Copyright 2015  
#
module Grape
  module Support
    module Enum

      def all
        constants.map { |name| const_get(name) }
      end

    end
  end
end
