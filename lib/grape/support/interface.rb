# == interface
#
# == usage
#
#  module Implements
#    def hoge; end
#  end
#
#  interface Implements do
#    def hoge
#      puts 'hoge'
#    end
#  end
#
# Author: Yuji Mise
# Copyright 2014  
#
module Grape
  module Support
    module Interface
      extend ActiveSupport::Concern

      module ClassMethods

        def interface(mod)
          wants = mod.instance_methods(false) | mod.private_instance_methods(false)

          yield

          havings = instance_methods(false) | private_instance_methods(false)
          shortages = wants - havings

          unless shortages.empty?
            raise NotImplementedError, "shortage methods: #{shortages.inspect}"
          end

          self
        end

      end
    end
  end
end
