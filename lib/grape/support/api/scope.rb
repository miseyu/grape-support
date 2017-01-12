class Grape::Support::API::Scope
  attr_accessor :namespace
  include ActiveModel::Model
  include Her::Model
  use_api Grape::Support::API::AuthAPI

  parse_root_in_json :items, format: :active_model_serializers
end
