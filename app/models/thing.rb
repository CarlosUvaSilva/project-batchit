class Thing < ApplicationRecord


  acts_as_votable

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

  def total_votes
    self.votes_for.sum(:vote_weight)
  end

  def is_favorite?(a_user)
    vote = self.votes_for.where(voter_id: a_user.id).first
    if vote.nil?
      false
    else
      vote.vote_weight == 3
    end
  end
end
