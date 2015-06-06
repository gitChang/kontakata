require 'rails_helper'

RSpec.feature "Contacts", type: :feature do
  
	
	before(:each) do
		visit '/'
	end


  # callbacks
  # ...

  def attach_image
  	# show input file for testing purpose.
  	script = '$("input#fileInput").css({display: "block"});'
  	page.execute_script(script)
  	attach_file('fileInput', File.join(Rails.root, '/public/photos/steyr.jpg'))
  end


  def fill_fullname(fullname='Juan dela Cruz')
  	find('input.contact-full-name').set fullname
  end


  def fill_social_profile_url(url='https://twitter.com/bitRonin')
  	find('input.contact-social-profile-url').set url
  end


  def submit
  	click_button('Add')
  end


  # scenarios
  # ...

  scenario 'click toggler to hide form.', js: true do
  	sleep 3

    find('i.toggler').click

    sleep 3

  	expect(page).to_not have_css('div.ninja.shown')
  end


  scenario 'posting an empty form should be invalid.', js: true do
  	submit

  	sleep 2

  	expect(page).to have_content('Please select a Photo.')
  end


  scenario 'posting with Photo only data, should have text \'Please type your Full Name.\'', js: true do
  	attach_image
  	submit
  	
  	sleep 2

  	expect(page).to have_content('Please type your Full Name.')
  end


  scenario 'posting with Photo, Full Name only data, 
  					should have text \'Please specify Social Profile URL.\'', js: true do
  	attach_image
  	fill_fullname

  	submit
  	
  	sleep 1 # don't change this. still finding out why.

  	expect(page).to have_content('Please specify Social Profile URL.')
  end


  scenario 'posting with Photo, Full Name, Social Profile URL only data, 
  					should have text \'Please type your Mobile Number.\'', js: true do
  	attach_image
  	fill_fullname

  	fill_social_profile_url

    sleep 3

  	submit

    sleep 3

  	expect(page).to have_content('Please type your Mobile Number.')
  end

end
