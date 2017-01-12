#
# session model
#
class Grape::Support::API::Session
  include ActiveModel::Model

  attr_accessor :email, :password,
    :account_id, :auth_token, :refresh_token, :scopes, :user

  class Entity
    include Her::Model
    use_api Grape::Support::API::AuthAPI
  end

  def create
    params = {
      email: email,
      password: password,
      grant_type: :password
    }
    result = Entity.post '/authenticates/password', params
    set_params result
    self.password = nil
  end

  def refresh
    result = Entity.get '/authenticates', refresh_token: refresh_token
    set_params result
  end

  def get
    result = Entity.get '/authenticates/me'
    set_params result
  end

  def destory
    Entity.delete '/authenticates'
  end

  def valid?
    account_id.present?
  end

  def manager?
    return if scopes.blank?
    scopes.find { |scope| scope.namespace == Grape::Support.manager_namescope }
  end

  private def set_params(params)
    return if params[:id].blank?
    self.account_id = params[:id]
    self.auth_token = params[:auth_token]
    self.refresh_token = params[:refresh_token]
    self.scopes = params[:scopes].map do |scope|
      scope_model = Grape::Support::API::Scope.new
      scope_model.namespace = scope[:namespace]
      scope_model
    end
  end

end
