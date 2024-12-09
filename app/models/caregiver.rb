class Caregiver < ApplicationRecord
  has_many :caregiver_skills, dependent: :destroy
  has_many :skills, through: :caregiver_skills
  has_many :caregiver_equipments, class_name: 'CaregiverEquipment', dependent: :destroy
  has_many :equipments, through: :caregiver_equipments
  has_many :supports, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true

  def matches_support?(support)
    missing_skills = support.skills - skills
    missing_equipments = support.equipments - equipments
    { match: missing_skills.empty? && missing_equipments.empty?, missing_skills: missing_skills, missing_equipments: missing_equipments }
  end

  def match_score(support)
    total_requirements = support.skills.count + support.equipments.count
    matched_skills = (skills & support.skills).count
    matched_equipments = (equipments & support.equipments).count
    (matched_skills + matched_equipments).to_f / total_requirements
  end
end
