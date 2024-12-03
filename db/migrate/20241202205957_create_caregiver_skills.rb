class CreateCaregiverSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :caregiver_skills do |t|
      t.references :caregiver, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
