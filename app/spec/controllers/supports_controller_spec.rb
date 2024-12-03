require 'rails_helper'

RSpec.describe SupportsController, type: :controller do
  let(:user) { User.create(email: "test@example.com", password: "password") }
  let(:caregiver) { Caregiver.create(name: "John Doe", skills: "Nursing") }
  let(:support) { Support.create(name: "Support 1", description: "Description 1", user: user, caregiver: caregiver) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: support.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    it "creates a new Support" do
      expect {
        post :create, params: { support: { name: "Support 2", description: "Description 2", user_id: user.id, caregiver_id: caregiver.id } }
      }.to change(Support, :count).by(1)
    end
  end

  describe "PATCH #update" do
    it "updates the requested support" do
      patch :update, params: { id: support.id, support: { name: "Updated Support" } }
      support.reload
      expect(support.name).to eq("Updated Support")
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested support" do
      support = Support.create!(name: "Support 3", description: "Description 3", user: user, caregiver: caregiver)
      expect {
        delete :destroy, params: { id: support.id }
      }.to change(Support, :count).by(-1)
    end
  end
end
