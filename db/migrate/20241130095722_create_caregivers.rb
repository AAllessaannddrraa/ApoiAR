class CreateCaregivers < ActiveRecord::Migration[7.1]
  def change
    create_table :caregivers do |t|
      t.string :name
      t.text :skills

      t.timestamps
    end
  end
end
