module ImageOptimizer
  class S3
    DEFAULT_PROCESSING_OPTIONS = {
      resizing_type: "fill",
      gravity: "sm"
    }.freeze

    def initialize(image_key, **options)
      @image_key = image_key
      @options = options
    end

    def self.call(...)
      new(...).call
    end

    def call
      uri = s3_uri
      Imgproxy.url_for(uri, DEFAULT_PROCESSING_OPTIONS.merge(@options)) if uri.present?
    end

    private

    def s3_uri
      image_bucket = Rails.application.credentials.dig(:aws, :bucket_name)
      return nil if image_bucket.blank? || @image_key.blank?

      "s3://#{Rails.application.credentials.dig(:aws, :bucket_name)}/#{@image_key}"
    end
  end
end
