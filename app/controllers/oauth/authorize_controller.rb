module Oauth
  class AuthorizeController < ApplicationController
    skip_before_action :doorkeeper_authorize!

    def index
      provider_class = Authentication::Providers::Provider.for(authorize_params[:provider])

      redirect_to provider_class.authorize_url(authorize_params[:redirect_uri])
    end

    private

    def authorize_params
      params.permit(:provider, :redirect_uri)
    end
  end
end
