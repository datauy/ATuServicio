require 'rails_helper'

describe 'Home spec' do
  it 'sees the home page and its content' do
    visit '/'
    expect(page).to have_content('Prestador')
    # TODO - Order, params (state)
  end
end
