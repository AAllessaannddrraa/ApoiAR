class Support < ApplicationRecord
  has_many :support_skills
  has_many :skills, through: :support_skills
  has_many :support_equipments
  has_many :equipments, through: :support_equipments
  has_many :caregivers, dependent: :destroy
  belongs_to :caregiver, optional: true

  validates :name, presence: true
  validates :description, presence: true
end
