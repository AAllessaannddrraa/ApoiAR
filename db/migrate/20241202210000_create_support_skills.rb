class CreateSupportSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :support_skills do |t|
      t.references :support, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
