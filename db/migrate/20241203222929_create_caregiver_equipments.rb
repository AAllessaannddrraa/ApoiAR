class CreateCaregiverEquipments < ActiveRecord::Migration[7.1]
  def change
    create_table :caregiver_equipments do |t|
      t.references :caregiver, null: false, foreign_key: true
      t.references :equipment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
