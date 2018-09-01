require 'rails_helper'

RSpec.describe "Pia", type: :request do
  describe "GET /pia" do
    it "works! (now write some real specs)" do
      get pia_path
      expect(response).to have_http_status(200)
    end
  end
end
