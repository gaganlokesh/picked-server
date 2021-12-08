class ProfileImageUploader < CarrierWave::Uploader::Base
  SUPPORTED_FORMATS = %w[jpg jpeg gif png].freeze

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    SUPPORTED_FORMATS
  end

  def size_range
    1..(2.megabytes)
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(8))
  end
end
