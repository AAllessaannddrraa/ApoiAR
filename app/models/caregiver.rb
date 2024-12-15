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
    return { match: false, missing_skills: [], missing_equipments: [] } if support.nil? || !support.respond_to?(:skills) || !support.respond_to?(:equipments)

    skills_to_match = support.skills || []
    equipments_to_match = support.equipments || []

    missing_skills = skills_to_match - skills
    missing_equipments = equipments_to_match - equipments
    { match: missing_skills.empty? && missing_equipments.empty?, missing_skills: missing_skills, missing_equipments: missing_equipments }
  end

  def match_score(support)
    Rails.logger.info "Calculating score for support: #{support.inspect}"
    return 0 if support.nil? || !support.respond_to?(:skill_ids) || !support.respond_to?(:equipment_ids)
    return 0 if support.skill_ids.blank? && support.equipment_ids.blank?

    support_skills = support.skill_ids || []
    support_equipments = support.equipment_ids || []

    Rails.logger.info "Skill IDs: #{support_skills}, Equipment IDs: #{support_equipments}"

    skill_match_count = (skills.pluck(:id) & support_skills).count
    equipment_match_count = (equipments.pluck(:id) & support_equipments).count

    total_skills = [support_skills.size, 1].max
    total_equipments = [support_equipments.size, 1].max

    # Weighted formula
    score = (((skill_match_count * 0.7) + (equipment_match_count * 0.3)) / ((total_skills * 0.7) + (total_equipments * 0.3))) * 10
    Rails.logger.info "Calculated score: #{score}"
    score
  end
end
