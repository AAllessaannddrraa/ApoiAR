# app/models/equipment.rb
class Equipment < ApplicationRecord
  has_many :support_equipments
  has_many :supports, through: :support_equipments
  has_many :caregiver_equipments
  has_many :caregivers, through: :caregiver_equipments
end
