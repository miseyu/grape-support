class Grape::Support::API::TokenAuthentication < Faraday::Middleware
  def call(env)
    env[:request_headers]["X-Http-Auth-Token"] = RequestStore.store[Grape::Support::API::RequestStoreKey::AUTH_TOKEN]
    @app.call(env)
  end
end
