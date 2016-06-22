class City < ActiveRecord::Base

  # Helpers
  audited

  # Relations
  belongs_to :country

  # Validations
  validates_presence_of :name, :country_id

end
