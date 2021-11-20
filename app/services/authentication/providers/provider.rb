module Authentication
  module Providers
    class Provider
      attr_reader :code, :redirect_uri

      def initialize(code, redirect_uri = nil)
        @code = code
        @redirect_uri = redirect_uri
      end

      def provider_name
        self.class.name.demodulize.downcase.to_sym
      end

      def self.provider_name
        name.demodulize.downcase.to_sym
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
