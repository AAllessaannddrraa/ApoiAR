class Caregiver < ApplicationRecord
  has_many :caregiver_skills
  has_many :skills, through: :caregiver_skills
  has_many :caregiver_equipments, class_name: 'CaregiverEquipment'
  has_many :equipments, through: :caregiver_equipments

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true

  # Método para verificar correspondência com um suporte
  def matches_support?(support)
    missing_skills = support.skills - skills
    missing_equipments = support.equipments - equipments
    { match: missing_skills.empty? && missing_equipments.empty?, missing_skills: missing_skills, missing_equipments: missing_equipments }
  end
end
