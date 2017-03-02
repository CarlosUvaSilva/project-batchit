class City < ApplicationRecord

  has_many :things
  belongs_to :project
  validates :name, presence: true

  def restaurants
    self.things.where(thing_type: "restaurant")
  end

  def bars
    self.things.where(thing_type: "bar")
  end

  def accommodations
    self.things.where(thing_type: "accommodation")
  end

  def activities
    self.things.where(thing_type: "activity")
  end
end
