class Invitation < ActiveRecord::Base
  belongs_to :invitee, class_name: 'User'
  belongs_to :inviter, class_name: 'User'

  def self.not_accepted
    where(accepted: false)
  end
end
