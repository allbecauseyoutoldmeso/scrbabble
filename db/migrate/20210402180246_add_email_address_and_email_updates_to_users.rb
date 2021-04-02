class AddEmailAddressAndEmailUpdatesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :email_address, :string
    add_column :users, :email_updates, :boolean, default: false
  end
end
