class Country < ActiveRecord::Base

  # Relations
  has_many :cities, dependent: :restrict_with_error

  # Validations
  validates_presence_of :name

end
