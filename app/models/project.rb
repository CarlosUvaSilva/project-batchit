class Project < ApplicationRecord

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 20 }
  validates :group_size, presence: true, inclusion: { in: (1..15) }
  validates :start_date, presence: true
  validates :end_date, presence: true

  has_many :participants
  has_many :cities
end
