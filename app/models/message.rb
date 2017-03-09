class Message < ApplicationRecord
  belongs_to :project
  belongs_to :participant

  def user
    self.participant.user
  end
end
