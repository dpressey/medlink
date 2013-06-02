require 'spec_helper'

describe OrdersController do
  let (:current_user) { FactoryGirl.create(:user) }
  let (:pc_hub) { FactoryGirl.create(:pc_hub) }
  before {
    sign_in current_user
  }

  describe "POST 'create'" do
    it "returns http success" do
      post 'create', order: {user_id: current_user.id, pc_hub_id: pc_hub.id}
      response.should be_success
    end
  end
  describe "POST 'create' nested requests" do
    let (:supply) { FactoryGirl.create(:supply) }
    it "returns http success" do
      order = {user_id: current_user.id, pc_hub_id: pc_hub.id}
      order[:requests_attributes] = [
        {supply_id: supply.id, dose: '5', quantity: 5},
        {supply_id: supply.id, dose: '10', quantity: 15}
      ]
      post 'create', order: order
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    let :example do
      FactoryGirl.create(:order, user_id: current_user.id)
    end
    it "returns http success" do
      delete 'destroy', id: example.id
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    let :example do
      FactoryGirl.create(:order, user_id: current_user.id)
    end
    it "returns http success" do
      put :update, id: example.id, order: {phone: '678-315-5999'}
      response.should be_success
    end
  end

end
