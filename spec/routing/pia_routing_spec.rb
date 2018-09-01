require "rails_helper"

RSpec.describe PiaController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/pia").to route_to("pia#index")
    end

    it "routes to #new" do
      expect(:get => "/pia/new").to route_to("pia#new")
    end

    it "routes to #show" do
      expect(:get => "/pia/1").to route_to("pia#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/pia/1/edit").to route_to("pia#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/pia").to route_to("pia#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/pia/1").to route_to("pia#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/pia/1").to route_to("pia#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pia/1").to route_to("pia#destroy", :id => "1")
    end

  end
end
