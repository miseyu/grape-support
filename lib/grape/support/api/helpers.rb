module Grape
  module Support
    module API
      module Helpers

        PRIVATE_TOKEN_HEADER = 'X-Http-Auth-Token'

        def current_session
          @current_session ||= begin
                              session = Grape::Support::API::Session.new
                              session.get
                              return unless session.valid?
                              session
                            end
        end

        def auth_token_param
          (headers[PRIVATE_TOKEN_HEADER] || params[PRIVATE_TOKEN_PARAM]).to_s
        end

        def paginate(object)
          return object if params[:page].blank?
          page = params[:page]
          per_page = params[:per_page]
          result = object.try(:page, page).try(:per, per_page)
          return object unless result
          result
        end

        def present_paging(items: , with: , options: {})
          total_count = items.count
          items = paginate(items)
          items = yield(items) if block_given?
          options[:with] = with
          items = with.represent items, options
          { items: items['items'], total_count: total_count }
        end

        def logger
          Rails.logger
        end

        def forbidden!
          render_api_error!('403 Forbidden', 403)
        end

        def bad_request!(attribute = '')
          message = ["400 (Bad request)"]
          message << "\"" + attribute.to_s + "\" not given"
          render_api_error!(message.join(' '), 400)
        end

        def not_found!(resource = nil)
          message = ["404"]
          message << resource if resource
          message << "Not Found"
          render_api_error!(message.join(' '), 404)
        end

        def unauthorized!(message = '401 Unauthorized Error')
          render_api_error! message, 401
        end

        def password_expired!(message = '401 Password Expired Error')
          render_api_error! message, 401, reason_code: :password_expired
        end

        def not_allowed!
          render_api_error!('Method Not Allowed', 405)
        end

        def validate_error!(message)
          render_api_error!(message, 400)
        end

        def render_api_error!(message, status, reason_code: nil)
          messages = []
          messages << message
          logger.error "api error! status = #{status}. cause. #{messages.flatten}"
          result = { errors: messages.flatten }
          result[:reason_code] = reason_code if reason_code.present?
          error!(result, status)
        end

        def success
          present :result, :success
        end

      end

      module SharedParams
        extend Grape::API::Helpers

        params :pagination do
          optional :page, type: Integer
          optional :per_page, type: Integer
          optional :total_count, type: Integer
        end

        params :period do
          optional :start_date, type: Time
          optional :end_date, type: Time
        end
      end

    end
  end

end
