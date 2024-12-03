require 'rails_helper'

RSpec.describe CaregiversController, type: :controller do
  let(:user) { User.create(email: "test@example.com", password: "password") }
  let(:caregiver) { Caregiver.create(name: "John Doe", skills: "Nursing") }

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
      get :show, params: { id: caregiver.id }
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
    it "creates a new Caregiver" do
      expect {
        post :create, params: { caregiver: { name: "Jane Doe", skills: "Cooking" } }
      }.to change(Caregiver, :count).by(1)
    end
  end

  describe "PATCH #update" do
    it "updates the requested caregiver" do
      patch :update, params: { id: caregiver.id, caregiver: { name: "Updated Caregiver" } }
      caregiver.reload
      expect(caregiver.name).to eq("Updated Caregiver")
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested caregiver" do
      caregiver = Caregiver.create!(name: "Jane Doe", skills: "Cooking")
      expect {
        delete :destroy, params: { id: caregiver.id }
      }.to change(Caregiver, :count).by(-1)
    end
  end
end
