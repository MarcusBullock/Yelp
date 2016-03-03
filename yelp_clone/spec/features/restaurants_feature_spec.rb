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
      sign_up
    end


    scenario '-> should correctly display the added restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'Hawksmoor'
      expect(page).not_to have_content 'No restaurants yet'
    end
  end


  context 'User Adding Restaurants' do

    before do
      sign_up
    end

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
      sign_up
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
      sign_up
    end

    scenario '-> removes a restaurant when a user clicks a delete link' do
      visit('/restaurants')
      click_link 'Delete Hawksmoor'
      expect(page).not_to have_content 'Hawksmoor'
      expect(page).to have_content 'Restaurant deleted successfully'
    end
  end

  context 'Creating Restaurants' do

    before do
      sign_up
    end

    context ' -> Invalid Restaurant' do
      scenario '-> it does not let you enter in a name that is too short' do
        visit('/restaurants')
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'hm'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'hm'
        expect(page).to have_content 'error'
      end

      scenario '-> it requires a unique name' do
        Restaurant.create(name: 'Bar')
        restaurant = Restaurant.new(name: 'Bar')
        expect(restaurant).to have(1).error_on(:name)
      end
    end
  end


  context 'user limitations' do

    scenario '-> should not let the user create reviews when not logged in' do
      visit('/restaurants')
      click_link 'Add a restaurant'
      expect(current_path).to eq('/users/sign_in')
    end

    scenario "-> should not reviews be deleted by non-logged in users" do
      Restaurant.create(name: 'Bar')
      visit('/restaurants')
      click_link 'Delete Bar'
      expect(current_path).to eq('/users/sign_in')
    end

    scenario "-> users can only delete reviews they have created" do
      Restaurant.create(name: 'Bar')
      sign_up
      review
      review
      expect(page).to have_content('Users can only leave one review per restaurant')
    end
  end
end

def sign_up
  visit('/users/sign_up')
  fill_in('Email', with: 'test@example.com')
  fill_in('Password', with: 'testtest')
  fill_in('Password confirmation', with: 'testtest')
  click_button('Sign up')
end

def review
  Restaurant.create(name: 'Bar')
  visit('/restaurants')
  click_link('Review Bar')
  fill_in('Thoughts', with: 'Great')
  select '5', from: 'Rating'
  click_button('Leave Review')
end
