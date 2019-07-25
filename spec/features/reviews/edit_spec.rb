require 'rails_helper'

RSpec.describe 'Edit Review Page' do
  describe 'As a Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @review_1 = @ogre.reviews.create(title: 'Great!', description: 'This Ogre is Great!', rating: 5)
      @review_2 = @ogre.reviews.create(title: 'Meh.', description: 'This Ogre is Mediocre', rating: 3)
      @review_3 = @ogre.reviews.create(title: 'EW', description: 'This Ogre is Ew', rating: 2)
    end

    it 'I can link to an edit review form from the item show page' do
      visit item_path(@ogre)

      within "#review-#{@review_1.id}" do
        click_button 'Edit'
      end

      expect(current_path).to eq(edit_review_path(@review_1))
    end

    it 'I can edit a single review attribute from the edit review page' do
      visit edit_review_path(@review_1)

      updated_title = "Super Great!"

      fill_in 'Title', with: updated_title
      click_button 'Update Review'

      expect(current_path).to eq(item_path(@ogre))
      within "#review-#{@review_1.id}" do
        expect(page).to have_content(updated_title)
        expect(page).to have_content(@review_1.description)
        expect(page).to have_content("Rating: #{@review_1.rating}")
      end
    end

    it 'I can edit all review attributes from the edit review page' do
      visit edit_review_path(@review_1)

      updated_title = "Super Great!"
      updated_description = "this thing is super duper"
      updated_rating = 5

      fill_in 'Title', with: updated_title
      fill_in 'Description', with: updated_description
      fill_in 'Rating', with: updated_rating
      click_button 'Update Review'

      expect(current_path).to eq(item_path(@ogre))
      within "#review-#{@review_1.id}" do
        expect(page).to have_content(updated_title)
        expect(page).to have_content(updated_description)
        expect(page).to have_content("Rating: #{updated_rating}")
      end
    end
  end
end
