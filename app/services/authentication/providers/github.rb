module Authentication
  module Providers
    class Github < Provider
      TOKEN_URL = "https://github.com/login/oauth/access_token".freeze
      USER_RESOURCE_URL = "https://api.github.com/user".freeze

      def authenticate
        @access_token = fetch_access_token
        return nil if @access_token.blank?

        user_response = fetch_user_data
        construct_user_hash_from_response(user_response)
      end

      private

      def fetch_access_token
        request_params = {
          code: auth_params[:code],
          client_id: Rails.application.credentials.dig(:github, :client_id),
          client_secret: Rails.application.credentials.dig(:github, :client_secret)
        }
        response = faraday_client.post(TOKEN_URL) do |req|
          req.headers["Content-Type"] = "application/x-www-form-urlencoded"
          req.headers["Accept"] = "application/json"
          req.body = URI.encode_www_form(request_params)
        end

        JSON.parse(response.body)["access_token"]
      end

      def fetch_user_data
        return if @access_token.blank?

        response = faraday_client.get(USER_RESOURCE_URL) do |req|
          req.headers["Authorization"] = "token #{@access_token}"
        end

        JSON.parse(response.body)
      end

      def construct_user_hash_from_response(response)
        {
          provider: provider_name,
          uid: response["id"].to_s,
          credentials: {
            token: @access_token,
            secret: nil
          },
          info: {
            username: response["login"],
            name: response["name"],
            email: response["email"],
            image: response["avatar_url"]
          }
        }
      end
    end
  end
end
