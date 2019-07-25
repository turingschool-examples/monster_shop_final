require 'rails_helper'

RSpec.describe 'Item Reviews Index' do
  describe 'As a Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @review_1 = @ogre.reviews.create(title: 'Great!', description: 'This Ogre is Great!', rating: 5)
      @review_2 = @ogre.reviews.create(title: 'Meh.', description: 'This Ogre is Mediocre', rating: 3)
      @review_3 = @ogre.reviews.create(title: 'EW', description: 'This Ogre is Ew', rating: 2)
    end

    it 'I can see an index of reviews on the item show page' do
      visit item_path(@ogre)

      within "#review-#{@review_1.id}" do
        expect(page).to have_content(@review_1.title)
        expect(page).to have_content(@review_1.description)
        expect(page).to have_content("Rating: #{@review_1.rating}")
      end

      within "#review-#{@review_2.id}" do
        expect(page).to have_content(@review_2.title)
        expect(page).to have_content(@review_2.description)
        expect(page).to have_content("Rating: #{@review_2.rating}")
      end

      within "#review-#{@review_3.id}" do
        expect(page).to have_content(@review_3.title)
        expect(page).to have_content(@review_3.description)
        expect(page).to have_content("Rating: #{@review_3.rating}")
      end
    end

    it 'I see an indication if an item has no reviews' do
      visit item_path (@giant)

      within '.reviews' do
        expect(page).to have_content('No Reviews Yet!')
      end
    end

    it 'I see an average rating for items with reviews' do
      visit item_path(@ogre)

      within '.reviews' do
        expect(page).to have_content("Average Rating: #{@ogre.average_rating.round(2)}")
      end
    end

    it 'I see the top 3 and bottom 3 reviews for the item' do
      visit item_path(@ogre)

      within '#top-three-reviews' do
        expect(page.all('li')[0]).to have_content(@review_1.title)
        expect(page.all('li')[1]).to have_content(@review_2.title)
        expect(page.all('li')[2]).to have_content(@review_3.title)
      end

      within '#bottom-three-reviews' do
        expect(page.all('li')[0]).to have_content(@review_3.title)
        expect(page.all('li')[1]).to have_content(@review_2.title)
        expect(page.all('li')[2]).to have_content(@review_1.title)
      end
    end
  end
end
