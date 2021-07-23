module Authentication
  module Providers
    class Provider
      attr_reader :access_token

      def initialize(access_token)
        @access_token = access_token
      end

      def provider_name
        self.class.name.demodulize.downcase.to_sym
      end

      def self.provider_name
        name.demodulize.downcase.to_sym
      end
    end
  end
end
