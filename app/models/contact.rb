class Contact < ActiveRecord::Base

	NUMERIC_REGEX = /\A[0-9.]+\z/


	before_save :titleize_full_name

	
	validates :file_name, 
							presence: { message: 'Please select a Photo.' }

	validates :full_name,
							presence: { message: 'Please type Full Name.' } 

	validates :full_name, 
							format: { with: /\A[a-zA-Z ]+\z/, message: 'Unacceptable Full Name.' },
							uniqueness: { 
								case_sensitive: false, 
								message: 'Full Name already exists.', on: :create 
							}

	validates :social_profile_url, 
							presence: { message: 'Please specify Social Profile URL.' }

	validates :social_profile_url, 
							uniqueness: { 
								case_sensitive: false, 
								message: 'Social Profile URL already exists.', on: :create 
							}

	validates :mobile_number, 
							presence: { message: 'Please Mobile Number.' }
	
	validates :mobile_number, 
							format: { with: /\A[0-9.]+\z/, message: 'Unacceptable Mobile Numbers.' }


	def self.full_name_exists?(full_name)
		where('lower(full_name) = ?', full_name.downcase).size > 0
	end


	private


		def titleize_full_name
			self.full_name = full_name.titleize
		end	

end
