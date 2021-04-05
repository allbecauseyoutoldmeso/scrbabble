class CreateInvitations < ActiveRecord::Migration[6.1]
  def change
    create_table :invitations do |t|
      t.references :inviter
      t.references :invitee
      t.boolean :accepted, default: false
    end
  end
end
