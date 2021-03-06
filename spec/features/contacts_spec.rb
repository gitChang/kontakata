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


  def fill_mobile_number(number='0926-540-5954')
    find('input.contact-mobile-number').set number
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


  scenario 'posting with Photo only data.', js: true do
    attach_image
    submit
    
    sleep 2

    expect(page).to have_content('Please type your Full Name.')
  end


  scenario 'posting with Photo, Full Name only data.', js: true do
    attach_image
    fill_fullname

    submit
    
    sleep 1 # don't change this. still finding out why.

    expect(page).to have_content('Please specify Social Profile URL.')
  end


  scenario 'posting with Photo, Full Name, Social Profile URL only data.', js: true do
    attach_image
    fill_fullname

    fill_social_profile_url

    sleep 3

    submit

    sleep 3

    expect(page).to have_content('Please type your Mobile Number.')
  end


  scenario 'Full Name has invalid character.', js: true do
    sleep 1
    fill_fullname('3ric')
    sleep 2

    expect(page).to have_content('Unacceptable Name.')
  end


  scenario 'Mobile Number has invalid character.', js: true do
    sleep 1
    fill_mobile_number('o928')
    sleep 2

    expect(page).to have_content('Unacceptable Mobile Number.')
  end


  scenario 'posting an invalid Full Name.', js: true do
    attach_image
    fill_fullname 'ch@rlie'
    fill_social_profile_url
    fill_mobile_number

    submit

    sleep 2

    expect(page).to have_content('Unacceptable Name.')
  end


  scenario 'posting an invalid Social Profile URL.', js: true do
    attach_image
    fill_fullname
    fill_social_profile_url 'http://foo.bar'
    fill_mobile_number

    submit

    sleep 2

    expect(page).to have_content('Invalid Social Profile URL.')
  end


  scenario 'posting an invalid Mobile Number.', js: true do
    attach_image
    fill_fullname
    fill_social_profile_url
    fill_mobile_number '092e'

    submit

    sleep 2

    expect(page).to have_content('Unacceptable Mobile Number.')
  end


  scenario 'posting valid contact data.', js: true do
    attach_image
    fill_fullname 'Charlie G. P.'

    sleep 2

    fill_social_profile_url

    sleep 2

    fill_mobile_number

    sleep 2

    submit

    sleep 4

    expect(page).to have_content('Charlie G. P.')
  end

end
