class View < ApplicationRecord
  belongs_to :article
  belongs_to :user

  counter_culture :article
end
