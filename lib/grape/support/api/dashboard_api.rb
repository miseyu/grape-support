Grape::Support::API::DashboardAPI = Her::API.new

Grape::Support::API::DashboardAPI.setup url: "#{Grape::Support.dashboard_api_host_url}" do |c|
  c.use Grape::Support::API::TokenAuthentication
  c.use Faraday::Request::UrlEncoded
  c.use Her::Middleware::DefaultParseJSON
  c.use Faraday::Adapter::NetHttp
end
