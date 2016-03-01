require 'rails_helper'

feature 'Reviewing' do

  before do
    Restaurant.create(name: 'Hawksmoor')
  end

  scenario '-> allows users to leave a review' do
    visit('/restaurants')
    click_link 'Review Hawksmoor'
    fill_in "Thoughts", with: "cracking nosh"
    select '5', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('cracking nosh')
  end
end 
