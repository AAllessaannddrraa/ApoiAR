class RemoveSupportIdFromCaregivers < ActiveRecord::Migration[7.1]
  def change
    remove_column :caregivers, :support_id, :integer
  end
end
