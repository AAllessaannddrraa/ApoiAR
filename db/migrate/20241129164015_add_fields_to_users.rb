class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :phone, :string
    add_column :users, :address, :string
    add_column :users, :notes, :text
  end
end
