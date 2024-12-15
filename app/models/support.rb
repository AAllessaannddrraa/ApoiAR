class Support < ApplicationRecord
  has_many :support_skills, dependent: :destroy
  has_many :skills, through: :support_skills
  has_many :support_equipments, dependent: :destroy
  has_many :equipments, through: :support_equipments
  belongs_to :user
  belongs_to :caregiver, optional: true

  validates :name, presence: true
  validates :description, presence: true

  def best_match_caregiver
    Caregiver.all.map do |caregiver|
      caregiver.matches_support?(self)
      { caregiver: caregiver, score: caregiver.match_score(self) }
    end.max_by { |match| match[:score] }&.dig(:caregiver)
  end
end
