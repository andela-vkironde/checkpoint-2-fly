class Airport < ApplicationRecord
  validates :code, :presence => true, :uniqueness => true
  validates :name, :city, :country, :latitude,
    :longitude, :presence => true

  def formatted
    "#{country} - #{city} - #{name} (#{code})"
  end
  
  scope :airports_all, -> { order("id ASC") }

end
