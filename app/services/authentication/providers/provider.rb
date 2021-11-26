module Authentication
  module Providers
    class Provider
      attr_reader :auth_params, :redirect_uri

      def initialize(auth_params, redirect_uri = nil)
        @auth_params = auth_params
        @redirect_uri = redirect_uri
      end

      def provider_name
        self.class.name.demodulize.downcase.to_sym
      end

      def self.provider_name
        name.demodulize.downcase.to_sym
      end

      def self.for(provider_name)
        Authentication::Providers.const_get(provider_name.to_s.capitalize)
      end

      protected

      def faraday_client
        Faraday.new do |faraday|
          faraday.use Faraday::Response::RaiseError
        end
      end
    end
  end
end
