module Authentication
  module Providers
    class Twitter < Provider
      API_URL = "https://api.twitter.com".freeze
      USER_RESOURCE_URL = "https://api.twitter.com/1.1/account/verify_credentials.json".freeze

      CONSUMER = OAuth::Consumer.new(
        Rails.application.credentials.dig(:twitter, :consumer_key),
        Rails.application.credentials.dig(:twitter, :consumer_secret),
        site: API_URL
      )

      def authenticate
        @access_token = fetch_access_token
        return nil if @access_token.blank?

        user_response = fetch_user_data
        construct_user_hash_from_response(user_response)
      end

      def self.authorize_url(callback_url)
        request_token = CONSUMER.get_request_token(oauth_callback: callback_url)

        # Save request tokens temporarily to verify request authenticity after authorization
        OauthRequestToken.create(token: request_token.token, secret: request_token.secret)

        request_token.authorize_url(oauth_callback: callback_url)
      end

      private

      def fetch_access_token
        saved_token = OauthRequestToken.find_by(token: auth_params[:oauth_token])
        return nil if saved_token.nil?

        request_token = OAuth::RequestToken.from_hash(
          CONSUMER,
          {
            oauth_token: saved_token.token,
            oauth_token_secret: saved_token.secret
          }
        )
        @access_token = request_token.get_access_token(oauth_verifier: auth_params[:oauth_verifier])

        # Remove saved request tokens from database
        saved_token.destroy

        @access_token
      end

      def fetch_user_data
        # TODO: Add params to resource URL to include user email as part of response
        # This requires providing TOS and Privacy Policy to Twitter
        response = @access_token.get(USER_RESOURCE_URL)

        JSON.parse(response.body)
      end

      def construct_user_hash_from_response(response)
        {
          provider: provider_name,
          uid: response["id"].to_s,
          credentials: {
            token: @access_token.token,
            secret: @access_token.secret
          },
          info: {
            username: response["screen_name"],
            name: response["name"],
            email: response["email"],
            image: response["profile_image_url_https"]&.to_s&.gsub("_normal", "")
          }
        }
      end
    end
  end
end
