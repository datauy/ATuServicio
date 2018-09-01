require 'rails_helper'

RSpec.describe "pia/index", type: :view do
  before(:each) do
    assign(:pia, [
      Pium.create!(),
      Pium.create!()
    ])
  end

  it "renders a list of pia" do
    render
  end
end
