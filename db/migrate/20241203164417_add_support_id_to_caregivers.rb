class AddSupportIdToCaregivers < ActiveRecord::Migration[7.1]
  def change
    add_column :caregivers, :support_id, :integer
  end
end
