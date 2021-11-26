module Authentication
  class Authenticator
    def initialize(provider_name, auth_params, redirect_uri)
      provider_class = Authentication::Providers::Provider.for(provider_name)
      @provider = provider_class.new(auth_params, redirect_uri)
    end

    def self.call(...)
      new(...).call
    end

    def call
      return unless @provider

      user_response = @provider.authenticate
      @user = User.from_external_authorizer(user_response)
      return @user if identity_exists?

      @user.identities.create(
        provider: @provider.provider_name,
        uid: user_response[:uid],
        token: user_response.dig(:credentials, :token),
        secret: user_response.dig(:credentials, :secret)
      )
      @user
    end

    private

    def identity_exists?
      @user.identities.exists?(provider: @provider.provider_name)
    end
  end
end
