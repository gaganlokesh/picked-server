module Authentication
  module Providers
    class Google < Provider
      TOKEN_URL = "https://www.googleapis.com/oauth2/v3/token".freeze
      USER_RESOURCE_URL = "https://www.googleapis.com/oauth2/v3/userinfo".freeze

      def initialize(access_code)
        super
        @user_data = user_data
      end

      def credentials
        {
          client_id: Rails.application.credentials.dig(:google, :client_id),
          client_secret: Rails.application.credentials.dig(:google, :client_secret)
        }
      end

      def fetch_access_token!
        if @access_token.present?
          @access_token
        else
          params = {
            client_id: credentials[:client_id],
            client_secret: credentials[:client_secret],
            grant_type: "authorization_code",
            redirect_uri: "http://localhost:8080", # FIXME: Adding this as placeholder for now
            code: @access_code
          }
          response = Faraday.post(TOKEN_URL) do |req|
            req.params = params
          end
          data = JSON.parse(response.body)

          @access_token ||= data["access_token"] if data["access_token"].present?
        end
      end

      def user_data
        fetch_access_token!

        if @access_token.present?
          response = Faraday.get(USER_RESOURCE_URL) do |req|
            req.headers["Authorization"] = "Bearer #{@access_token}"
          end

          body_mapper(JSON.parse(response.body))
        end
      end

      def user!
        User.from_external_authorizer(@user_data) if @user_data.present?
      end

      private

      def body_mapper(user)
        {
          provider: provider_name,
          uid: user["sub"],
          info: {
            name: user["name"],
            email: user["email"],
            image: user["picture"]
          }
        }
      end
    end
  end
end
