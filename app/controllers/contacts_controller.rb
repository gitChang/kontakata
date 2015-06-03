require 'base64'

class ContactsController < ApplicationController
	
	layout 'application'

	
	# Landing page. Collects all 
	# contacts registered.
	def index
	end


	# Add new contact person
	def create
		contact = Contact.new(contact_params)

		if contact.save
			decoded_64 = Base64.decode64( params[:image_data].to_s.split(',')[1] )

			file = File.new("public/photos/#{params[:file_name].to_s}", 'wb')
		  file.write(decoded_64)

			render json: contact.as_json
		else	
			first_error = contact.errors.first[1]
			puts first_error
			
			render json: { error: first_error }.as_json, status: 400
		end
	end


	# AJAX REQUEST ZONE

	def get_all_contacts
		contacts = Contact.order('created_at DESC')
		render json: contacts.as_json
	end


	def check_full_name
		exists = Contact.full_name_exists?(params[:full_name])
		render json: { exists: exists }.as_json
	end


	def check_social_link
		url_valid = Contact.verify_url(params[:url])

		if url_valid
			head 200
		else
			head 404
		end
	end


	private


		def contact_params
			params.permit(:file_name, :full_name, :social_profile_url, :mobile_number)
		end

end
