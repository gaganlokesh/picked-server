module Authentication
  module Providers
    class Github < Provider
      TOKEN_ENDPOINT = "https://github.com/login/oauth/access_token".freeze
      USER_RESOURCE_ENDPOINT = "https://api.github.com/user".freeze

      def fetch_access_token
        request_params = {
          code: @code,
          client_id: Rails.application.credentials.dig(:github, :client_id),
          client_secret: Rails.application.credentials.dig(:github, :client_secret)
        }
        response = faraday_client.post(TOKEN_ENDPOINT) do |req|
          req.headers["Content-Type"] = "application/x-www-form-urlencoded"
          req.headers["Accept"] = "application/json"
          req.body = URI.encode_www_form(request_params)
        end

        JSON.parse(response.body)["access_token"]
      end

      def fetch_user_data
        access_token = fetch_access_token
        return if access_token.blank?

        response = faraday_client.get(USER_RESOURCE_ENDPOINT) do |req|
          req.headers["Authorization"] = "token #{access_token}"
        end

        construct_user_hash_from_response(JSON.parse(response.body))
      end

      def user!
        user = fetch_user_data
        return nil if user.blank?

        User.from_external_authorizer(user)
      end

      private

      def construct_user_hash_from_response(user)
        {
          provider: provider_name,
          uid: user["id"].to_s,
          info: {
            username: user["login"],
            name: user["name"],
            email: user["email"],
            image: user["avatar_url"]
          }
        }
      end
    end
  end
end
