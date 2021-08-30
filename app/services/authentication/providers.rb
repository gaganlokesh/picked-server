module Authentication
  module Providers
    def self.all
      Authentication::Providers::Provider.subclasses.map(&:provider_name).sort
    end
  end
end
