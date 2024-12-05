class CaregiverEquipment < ApplicationRecord
  belongs_to :caregiver
  belongs_to :equipment
end
