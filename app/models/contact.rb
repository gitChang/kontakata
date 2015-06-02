require 'net/http'
require 'uri'

class Contact < ActiveRecord::Base

	NUMERIC_REGEX = /\A[0-9.]+\z/


	before_save :titleize_full_name

	
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


	def self.full_name_exists?(full_name)
		where('lower(full_name) = ?', full_name.downcase).size > 0
	end


	def self.verify_social_profile_url(url)
		hosts = ['www.facebook.com', 'twitter.com', 'goo.gl', 'bit.ly', 'ow.ly']
		messages = { bad: 'Bad URL.', valid: 'Valid URL.', tmr: 'TMR.' }

		if !(url =~ URI::regexp)
			return { valid: false, result: messages[:bad] }
		end

		response = Net::HTTP.get_response( URI(url) )

		if !hosts.include? URI(url).host
			return { valid: false, result: messages[:bad] }
		end

		if response.is_a? Net::HTTPRedirection
			location = response['location']

			if !("#{hosts[0]}#{hosts[1]}").split('').include? URI(location).host
				return { valid: false, result: messages[:bad] }
			end

			redirect = Net::HTTP.get_response(URI(location))

			return { valid: false, result: messages[:tmr] } if redirect.is_a? Net::HTTPRedirection
			
			return { valid: true, result: location }
		end

		if response.is_a? Net::HTTPSuccess
			render json: { valid: true, result: messages[:valid] }
			return
		end

		# Default to 400.
		return render json: { valid: false, result: messages[:bad] }
	end


	private


		def titleize_full_name
			self.full_name = full_name.titleize
		end	

end
