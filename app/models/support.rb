class Support < ApplicationRecord
  belongs_to :user
  has_many :support_skills, dependent: :destroy
  has_many :skills, through: :support_skills
  has_many :support_equipments, dependent: :destroy
  has_many :equipments, through: :support_equipments
  has_many :caregivers
  belongs_to :caregiver, optional: true

  validates :name, presence: true
  validates :description, presence: true
end
