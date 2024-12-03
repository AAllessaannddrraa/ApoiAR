require 'rails_helper'

RSpec.describe Support, type: :model do
  it "is valid with valid attributes" do
    user = User.create(email: "test@example.com", password: "password")
    caregiver = Caregiver.create(name: "John Doe", skills: "Nursing")
    support = Support.new(name: "Support 1", description: "Description 1", user: user, caregiver: caregiver)
    expect(support).to be_valid
  end

  it "is not valid without a name" do
    support = Support.new(name: nil)
    expect(support).to_not be_valid
  end

  it "is not valid without a description" do
    support = Support.new(description: nil)
    expect(support).to_not be_valid
  end
end
