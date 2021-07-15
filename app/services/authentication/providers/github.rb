module Authentication
  module Providers
    class Github < Provider
      TOKEN_URL = "https://github.com/login/oauth/access_token".freeze
      USER_RESOURCE_URL = "https://api.github.com/user".freeze

      def initialize(access_code)
        super
        @user_data = user_data
      end

      def credentials
        {
          client_id: Rails.application.credentials[:github][:client_id],
          client_secret: Rails.application.credentials[:github][:client_secret]
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
            code: access_code
          }
          response = Faraday.post(TOKEN_URL) do |req|
            req.params = params
            req.headers["Accept"] = "application/json"
          end
          data = JSON.parse(response.body)

          @access_token ||= data["access_token"] if data["access_token"].present?
        end
      end

      def user_data
        fetch_access_token!

        if @access_token.present?
          response = Faraday.get(USER_RESOURCE_URL) do |req|
            req.headers["Authorization"] = "token #{@access_token}"
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
