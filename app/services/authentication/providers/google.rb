module Authentication
  module Providers
    class Google < Provider
      USER_RESOURCE_URL = "https://www.googleapis.com/oauth2/v3/userinfo".freeze

      def initialize(access_token)
        super
        @user_data = fetch_user_data
      end

      def fetch_user_data
        if @access_token.present?
          response = Faraday.get(USER_RESOURCE_URL) do |req|
            req.headers["Authorization"] = "Bearer #{@access_token}"
          end

          user_hash(JSON.parse(response.body))
        end
      end

      def user!
        User.from_external_authorizer(@user_data) if @user_data.present?
      end

      private

      def user_hash(user)
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
