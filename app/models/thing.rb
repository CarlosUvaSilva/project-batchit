class Thing < ApplicationRecord

  belongs_to :city

  validates :name, presence: true
  validates :thing_type, presence: true
  validates :thing_type, inclusion: { in: %w(restaurant bar accommodation activity),
    message: "%{value} is not a valid size" }



  def is_restaurant?
    self.thing_type == 'restaurant'
  end

  def is_bar?
    self.thing_type == 'bar'
  end

  def is_accommodation?
    self.thing_type == 'accommodation'
  end

  def is_activity?
    self.thing_type == 'activity'
  end
end
