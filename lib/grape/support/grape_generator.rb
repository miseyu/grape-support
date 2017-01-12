require 'rails/generators'

module Grape
  module Support
    class GrapeGenerator < ::Rails::Generators::NamedBase
      source_root File.join(File.dirname(__FILE__), 'templates')

      def create_controller_files
        template "controller.rb", File.join('app/controllers/api', "#{class_name.underscore.pluralize}.rb")
      end

    end
  end
end
