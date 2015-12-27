require "rails_helper"

RSpec.describe ActivitiesController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    sign_in user
  end

  describe "#index" do
    let!(:user_activity) { create(:activity, user: user) }
    let!(:other_activity) { create(:activity, user: other_user) }

    it "lists user activities" do
      get :index

      result = JSON.parse response.body

      expect(result.count).to eql(1)
      expect(result[0]["id"]).to eql(user_activity.id)
    end
  end

  describe "#show" do
    let(:activity) { create(:activity, user: user) }

    it "returns activity" do
      get :show, id: activity.id

      result = JSON.parse response.body

      expect(result["id"]).to eql(activity.id)
    end

    context "other user's activity" do
      let(:unauthorized_activity) { create(:activity, user: other_user) }

      it "returns 401" do
        get :show, id: unauthorized_activity.id

        expect(response.status).to eql(401)
      end
    end
  end

  describe "#create" do
    let(:attributes) { { description: "Bought chipotle", amount: 8.14 } }

    it "creates activity for user" do
      expect {
        post :create, attributes
      }.to change {
        Activity.by_user(user).count
      }.from(0).to(1)
    end
  end

  describe "#update" do
    let(:activity) { create(:activity, description: "Carboload", user: user) }
    let(:attributes) { { id: activity.id, description: "Carbs n stuff" } }

    it "creates activity for user" do
      expect {
        put :update, attributes
      }.to change {
        activity.reload.description
      }.from("Carboload").to("Carbs n stuff")
    end
  end

  describe "#destroy" do
    let!(:activity) { create(:activity, description: "Jello molds", user: user) }

    it "removes activity" do
      expect {
        delete :destroy, id: activity.id
      }.to change {
        Activity.by_user(user).count
      }.from(1).to(0)
    end
  end
end
