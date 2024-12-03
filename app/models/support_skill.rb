# app/models/support_skill.rb
class SupportSkill < ApplicationRecord
  belongs_to :support
  belongs_to :skill
end
