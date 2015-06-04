require 'net/http'
require 'uri'

class Contact < ActiveRecord::Base

	NUMERIC_REGEX = /\A[0-9.]+\z/

  # callbacks
	before_validation :verify_social_profile_url

  before_save :titleize_full_name

	# validations
	validates :file_name, 
							presence: { message: 'Please select a photo.' }

	validates :full_name,
							presence: { message: 'Please type Full Name.' } 

	validates :full_name, 
							format: { with: /\A[a-zA-Z ]+\z/, message: 'Unacceptable Name.' },
							uniqueness: { 
								case_sensitive: false, 
								message: 'Name already exists.', on: :create 
							}

	validates :social_profile_url, 
							presence: { message: 'Please specify Social Profile URL.' }

	validates :mobile_number, 
							presence: { message: 'Please Mobile Number.' }
	
	validates :mobile_number, 
							format: { with: /\A[0-9.]+\z/, message: 'Unacceptable Mobile Number.' }


	# triggered via ajax request
	# of full name duplicates.
	def self.full_name_exists?(full_name)
		where('lower(full_name) = ?', full_name.downcase).size > 0
	end


	# checks the existence of
	# the social profile url.
	def self.verify_url(url)
		domain_allowed = %w(www.facebook.com twitter.com)

    return false if !(url =~ /\A#{URI::regexp(['http', 'https'])}\z/)
    return false if URI(url.to_s).path.empty?
		return false if !domain_allowed.include?(URI(url).host)

		response = Net::HTTP.get_response(URI(url))

		if response.is_a? Net::HTTPSuccess
			return true
		else
			return false
		end
	end


	private

		# callback for social profile
		# url validation.
		def verify_social_profile_url
			if !Contact.verify_url(social_profile_url)
				errors.add(:social_profile_url, 'Invalid Social Profile URL.')
			end
		end


    # before_save callback to reformat
    # charater casing.
		def titleize_full_name
			self.full_name = full_name.titleize
		end	

end
