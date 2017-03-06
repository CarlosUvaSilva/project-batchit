class Participant < ApplicationRecord




  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates_uniqueness_of :email, :scope => [:project_id], :message => "Buddy already invited for this trip"

  belongs_to :project
  # belongs_to user is optional as user will be nil if e-mail provided is not included in the
  # database yet. Once a new user registers, it will check if any participants with this e-mail address
  # exist in the dabatabe and will set the Participant.user = current_user (TO BE IMPLEMENTED)
  belongs_to :user, optional: true

end
