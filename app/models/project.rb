class Project < ApplicationRecord

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 20 }
  validates :group_size, presence: true, inclusion: { in: (1..15) }
  validates :start_date, presence: true
  validates :end_date, presence: true

  has_many :participants
  has_many :users, through: :participants
  has_many :cities, dependent: :destroy
  has_many :things, through: :cities

  def leader
    self.participants.where(is_leader: true).user
  end

  def completed?
    self.cities.first.things.size == 12 && self.cities.second.things.size == 12
  end

  def is_leader?(user)
    self.is_participant?(user) && !self.participants.where(user_id: user.id).first.is_leader.nil?
  end

  def leader_participant
    self.participants.where(is_leader: true).first
  end

  def leader_user
    self.leader_participant.user
  end

  def is_participant?(user)
    !self.participants.where(user_id: user.id).first.nil?
  end

  def get_participant(user)
    self.participants.where(user_id: user.id).first
  end

  def get_participant_votes(user)
    city1_votes = self.cities.first.votes_for.where(voter_id: user.id).size
    city2_votes = self.cities.second.votes_for.where(voter_id: user.id).size
    city1_votes + city2_votes
  end
end
