# app/models/skill.rb
class Skill < ApplicationRecord
  has_many :caregiver_skills
  has_many :caregivers, through: :caregiver_skills
  has_many :support_skills
  has_many :supports, through: :support_skills
end
