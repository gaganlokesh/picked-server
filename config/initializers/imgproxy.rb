Imgproxy.configure do |config|
  # Full URL to where your imgproxy lives.
  config.endpoint = Rails.application.credentials.dig(:imgproxy, :endpoint)

  # Hex-encoded signature key and salt
  config.key = Rails.application.credentials.dig(:imgproxy, :key)
  config.salt = Rails.application.credentials.dig(:imgproxy, :salt)

  # Use S3 URLs for images
  config.use_s3_urls = true
end
