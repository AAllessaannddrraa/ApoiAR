class AddCaregiverToSupports < ActiveRecord::Migration[7.0]
  def change
    add_reference :supports, :caregiver, foreign_key: true, null: true
  end
end
