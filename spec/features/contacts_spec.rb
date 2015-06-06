require 'rails_helper'

RSpec.feature "Contacts", type: :feature do
  
	
	before(:each) do
		visit '/'
	end


	scenario 'click toggler to hide form.', js: true do
		sleep 1

  	find('i.toggler').click

  	sleep 1

  	expect(page).to_not have_css('div.ninja.shown')
  end


  scenario 'posting an empty form should be invalid.', js: true do
  	sleep 1

  	click_button('Add')

  	sleep 1

  	expect(page).to have_content('Please select a Photo.')
  end

end
