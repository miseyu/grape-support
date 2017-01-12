Grape::Support::API::AuthAPI = Her::API.new

Grape::Support::API::AuthAPI.setup url: "#{Grape::Support.auth_api_host_url}" do |c|
  c.use Grape::Support::API::TokenAuthentication
  c.use Faraday::Request::UrlEncoded
  c.use Her::Middleware::DefaultParseJSON
  c.use Faraday::Adapter::NetHttp
end
