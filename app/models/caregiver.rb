class Caregiver < ApplicationRecord
  belongs_to :support
  has_many :caregiver_skills
  has_many :skills, through: :caregiver_skills

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
end
