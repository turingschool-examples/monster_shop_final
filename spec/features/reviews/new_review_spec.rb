require 'rails_helper'

RSpec.describe 'New Review Creation' do
  describe 'As a Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @review_1 = @ogre.reviews.create(title: 'Great!', description: 'This Ogre is Great!', rating: 5)
      @review_2 = @ogre.reviews.create(title: 'Meh.', description: 'This Ogre is Mediocre', rating: 3)
      @review_3 = @ogre.reviews.create(title: 'EW', description: 'This Ogre is Ew', rating: 1)
    end

    it 'I can link to a new review form from the item show page' do
      visit item_path(@ogre)

      within '.reviews' do
        click_button 'Add Review'
      end

      expect(current_path).to eq(new_item_review_path(@ogre))
    end

    it 'I can create a new review from the new review page' do
      visit new_item_review_path(@ogre)

      title = 'Super'
      description = 'It was pretty good'
      rating = 4

      fill_in 'Title', with: title
      fill_in 'Description', with: description
      fill_in 'Rating', with: rating
      click_button 'Create Review'

      new_review = Review.last

      expect(current_path).to eq(item_path(@ogre))
      within "#review-#{new_review.id}" do
        expect(page).to have_content(title)
        expect(page).to have_content(description)
        expect(page).to have_content("Rating: #{rating}")
      end
    end

    it 'I can not create a new review with a rating greater than 5' do
      visit new_item_review_path(@ogre)

      title = 'Super'
      description = 'It was pretty good'
      rating = 7

      fill_in 'Title', with: title
      fill_in 'Description', with: description
      fill_in 'Rating', with: rating
      click_button 'Create Review'

      expect(page).to have_content("Rating must be 1 - 5")
      expect(page).to have_button 'Create Review'
    end

    it 'I can not create a review with a rating less than 1' do
      visit new_item_review_path(@ogre)

      title = 'Super'
      description = 'It was pretty good'
      rating = 0

      fill_in 'Title', with: title
      fill_in 'Description', with: description
      fill_in 'Rating', with: rating
      click_button 'Create Review'

      expect(page).to have_content("Rating must be 1 - 5")
      expect(page).to have_button 'Create Review'
    end

    it 'I can not create a review without a title' do
      visit new_item_review_path(@ogre)

      title = 'Super'
      description = 'It was pretty good'
      rating = 4

      fill_in 'Description', with: description
      fill_in 'Rating', with: rating
      click_button 'Create Review'

      expect(page).to have_content("title: [\"can't be blank\"]")
      expect(page).to have_button 'Create Review'
    end

    it 'I can not create a review without a description' do
      visit new_item_review_path(@ogre)

      title = 'Super'
      description = 'It was pretty good'
      rating = 4

      fill_in 'Title', with: title
      fill_in 'Rating', with: rating
      click_button 'Create Review'

      expect(page).to have_content("description: [\"can't be blank\"]")
      expect(page).to have_button 'Create Review'
    end
  end
end
