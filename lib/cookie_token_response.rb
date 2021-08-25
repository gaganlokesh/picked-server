module CookieTokenResponse
  def body
    super.except("refresh_token")
  end

  def headers
    # TODO: Set appropriate cookie attributes for production
    cookie_args = [
      "refresh_token=#{token.plaintext_refresh_token}",
      "Path=/oauth/token",
      "Expires=#{(Time.current + 60.days).httpdate}",
      "HttpOnly",
      "Secure",
      "SameSite=None"
    ]
    cookie = cookie_args.join("; ")

    super.merge(
      {
        "Set-Cookie" => cookie
      }
    )
  end
end
