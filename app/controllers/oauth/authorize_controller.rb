module Oauth
  class AuthorizeController < ApplicationController
    skip_before_action :doorkeeper_authorize!

    GITHUB_OAUTH_ENDPOINT = "https://github.com/login/oauth/authorize".freeze
    GOOGLE_OAUTH_ENDPOINT = "https://accounts.google.com/o/oauth2/v2/auth".freeze

    def index
      uri = case params[:provider]
            when "github"
              authorize_with_github
            when "google"
              authorize_with_google
            end

      redirect_to uri
    end

    private

    def authorize_with_github
      github_params = query_params

      "#{GITHUB_OAUTH_ENDPOINT}?#{github_params.to_query}"
    end

    def authorize_with_google
      google_params = query_params.merge(
        scope: "profile email"
      )

      "#{GOOGLE_OAUTH_ENDPOINT}?#{google_params.to_query}"
    end

    def query_params
      {
        redirect_uri: params[:redirect_uri],
        client_id: Rails.application.credentials.dig(params[:provider].to_sym, :client_id),
        response_type: "code"
      }
    end
  end
end
