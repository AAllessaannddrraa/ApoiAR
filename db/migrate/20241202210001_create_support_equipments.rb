class CreateSupportEquipments < ActiveRecord::Migration[7.1]
  def change
    create_table :support_equipments do |t|
      t.references :support, null: false, foreign_key: true
      t.references :equipment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
