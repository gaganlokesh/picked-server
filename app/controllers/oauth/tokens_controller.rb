module Oauth
  class TokensController < Doorkeeper::TokensController
    # `create` action is defined in `Doorkeeper::TokensController`
    # rubocop:disable Rails/LexicallyScopedActionFilter
    before_action :set_refresh_token_from_cookie, only: [:create]
    # rubocop:enable Rails/LexicallyScopedActionFilter

    private

    def set_refresh_token_from_cookie
      return unless request.parameters[:grant_type] == "refresh_token"

      refresh_token = request.cookies["refresh_token"]
      request.parameters[:refresh_token] ||= refresh_token
    end
  end
end
