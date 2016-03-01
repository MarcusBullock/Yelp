require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'Hawksmoor')
    end

    scenario 'should correctly display the added restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'Hawksmoor'
      expect(page).not_to have_content 'No restaurants yet'
    end
  end

  context 'user adding restaurants' do
    scenario 'should display the restaurant the user added' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'Hawksmoor'
      click_button 'Create Restaurant'
      expect(page).to have_content('Hawksmoor')
      expect(current_path).to eq('/restaurants')
    end
  end

end
