class AddDetailsToCaregivers < ActiveRecord::Migration[7.1]
  def change
    add_column :caregivers, :email, :string
    add_column :caregivers, :phone, :string
  end
end
