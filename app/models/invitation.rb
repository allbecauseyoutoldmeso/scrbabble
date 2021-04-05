class Invitation < ActiveRecord::Base
  belongs_to :invitee, class_name: 'User'
  belongs_to :inviter, class_name: 'User'
end
