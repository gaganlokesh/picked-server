module Authentication
  module Providers
    class Github < Provider
      USER_RESOURCE_URL = "https://api.github.com/user".freeze

      def initialize(access_token)
        super
        @user_data = fetch_user_data
      end

      def fetch_user_data
        if @access_token.present?
          response = Faraday.get(USER_RESOURCE_URL) do |req|
            req.headers["Authorization"] = "token #{@access_token}"
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
