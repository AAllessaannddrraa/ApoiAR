require 'rails_helper'

RSpec.describe Caregiver, type: :model do
  it "is valid with valid attributes" do
    caregiver = Caregiver.new(name: "John Doe", skills: "Nursing")
    expect(caregiver).to be_valid
  end

  it "is not valid without a name" do
    caregiver = Caregiver.new(name: nil)
    expect(caregiver).to_not be_valid
  end

  it "is not valid without skills" do
    caregiver = Caregiver.new(skills: nil)
    expect(caregiver).to_not be_valid
  end
end
