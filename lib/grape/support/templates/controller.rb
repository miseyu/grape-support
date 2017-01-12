<% module_namespacing do -%>
# == <%= class_name.pluralize %> api
#
#
# Copyright 2015  
#
module API
  module <%= class_name.pluralize %>
    extend ActiveSupport::Concern

    included do
      resource :<%= class_name.underscore.pluralize %> do

        desc "Get List <%= class_name %>"
        params do
        end
        get do
        end

        desc "Get Single <%= class_name %>"
        params {}
        get ':id', requirements: { id: /[0-9]*/ } do
        end

        desc "Create <%= class_name %>"
        params do
        end
        post do
        end

        desc "Update <%= class_name %>"
        params do
        end
        put ':id', requirements: { id: /[0-9]*/ } do
        end

        desc "Delete <%= class_name %>"
        params do
        end
        delete ':id', requirements: { id: /[0-9]*/ } do
        end

      end
    end

  end
end
<% end -%>
