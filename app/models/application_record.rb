class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def validate_attribute(attribute)
    valid?
    errors[attribute].presence || []
  end
end
