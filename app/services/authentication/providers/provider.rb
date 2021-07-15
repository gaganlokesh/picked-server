module Authentication
  module Providers
    class Provider
      attr_reader :access_code

      def initialize(access_code)
        @access_code = access_code
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
