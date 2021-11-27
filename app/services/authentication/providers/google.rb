module Authentication
  module Providers
    class Google < Provider
      AUTHORIZATION_URL = "https://accounts.google.com/o/oauth2/v2/auth".freeze
      TOKEN_URL = "https://oauth2.googleapis.com/token".freeze
      USER_RESOURCE_URL = "https://www.googleapis.com/oauth2/v3/userinfo".freeze

      def authenticate
        @access_token = fetch_access_token
        return nil if @access_token.blank?

        user_response = fetch_user_data
        construct_user_hash_from_response(user_response)
      end

      def self.authorize_url(callback_url)
        query_params = {
          client_id: Rails.application.credentials.dig(:google, :client_id),
          response_type: "code",
          scope: "profile email",
          redirect_uri: callback_url
        }

        "#{AUTHORIZATION_URL}?#{query_params.to_query}"
      end

      private

      def fetch_access_token
        request_params = {
          grant_type: "authorization_code",
          code: auth_params[:code],
          client_id: Rails.application.credentials.dig(:google, :client_id),
          client_secret: Rails.application.credentials.dig(:google, :client_secret),
          redirect_uri: redirect_uri
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
          req.headers["Authorization"] = "Bearer #{@access_token}"
        end

        JSON.parse(response.body)
      end

      def construct_user_hash_from_response(response)
        {
          provider: provider_name,
          uid: response["sub"],
          credentials: {
            token: @access_token,
            secret: nil
          },
          info: {
            name: response["name"],
            email: response["email"],
            image: response["picture"]
          }
        }
      end
    end
  end
end
