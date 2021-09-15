# Global config for Blueprinter
Blueprinter.configure do |config|
  # Format for datetime values
  config.datetime_format = ->(datetime) { datetime&.utc&.iso8601 }
end
