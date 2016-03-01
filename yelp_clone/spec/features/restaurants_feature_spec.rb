require 'rails_helper'

feature 'Restaurants' do

  context 'No Restaurants Added' do

    scenario '-> should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end


  context 'Viewing Added Restaurant List' do

    before do
      Restaurant.create(name: 'Hawksmoor')
    end

    scenario '-> should correctly display the added restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'Hawksmoor'
      expect(page).not_to have_content 'No restaurants yet'
    end
  end


  context 'User Adding Restaurants' do

    scenario '-> should display the restaurant the user added' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'Hawksmoor'
      click_button 'Create Restaurant'
      expect(page).to have_content('Hawksmoor')
      expect(current_path).to eq('/restaurants')
    end
  end


  context 'Viewing Restaurants by Click' do

    let!(:hawksmoor){Restaurant.create(name: 'Hawksmoor')}

    scenario '-> lets users view the restaurants' do
      visit('/restaurants')
      click_link 'Hawksmoor'
      expect(page).to have_content 'Hawksmoor'
      expect(current_path).to eq "/restaurants/#{hawksmoor.id}"
    end
  end

  context 'Editing Restaurants' do

    before do
      Restaurant.create(name: 'Hawksmoor')
    end

    scenario '-> lets users edit restaurants in the list' do
      visit('/restaurants')
      click_link'Edit Hawksmoor'
      fill_in 'Name', with: 'The Hawksmoor'
      click_button 'Update Restaurant'
      expect(page).to have_content('The Hawksmoor')
      expect(current_path).to eq ('/restaurants')
    end
  end

  context 'Deleting Restaurants' do 

    before do
      Restaurant.create(name: 'Hawksmoor')
    end

    scenario '-> removes a restaurant when a user clicks a delete link' do
      visit('/restaurants')
      click_link 'Delete Hawksmoor'
      expect(page).not_to have_content 'Hawksmoor'
      expect(page).to have_content 'Restaurant deleted successfully'
    end
  end


end
