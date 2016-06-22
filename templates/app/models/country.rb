class Country < ActiveRecord::Base

  # Helpers
  audited

  # Relations
  has_many :cities, dependent: :restrict_with_error

  # Validations
  validates_presence_of :name

end
