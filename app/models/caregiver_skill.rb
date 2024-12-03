# app/models/caregiver_skill.rb
class CaregiverSkill < ApplicationRecord
  belongs_to :caregiver
  belongs_to :skill
end
