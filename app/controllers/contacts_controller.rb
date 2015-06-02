require 'net/http'
require 'uri'
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
		hosts = ['www.facebook.com', 'twitter.com', 'goo.gl', 'bit.ly', 'ow.ly']

		result = nil
		messages = { bad: 'Bad URL.', valid: 'Valid URL.', tmr: 'TMR.' }

		if !URI(params[:url]).host
			render json: { result: messages[:bad] }.as_json
			return
		end

		response = Net::HTTP.get_response( URI(params[:url]) )

		if !hosts.include? URI(params[:url]).host
			render json: { result: messages[:bad] }.as_json
			return
		end

		if URI(params[:url]).path.size < 4
			render json: { result: messages[:bad] }.as_json
			return
		end

		if response.is_a? Net::HTTPRedirection
			result = response['location']

			if !['www.facebook.com', 'twitter.com'].include?( URI(result).host )
				render json: { result: messages[:bad] }.as_json
				return
			end

			redirect = Net::HTTP.get_response(URI(result))
			result = messages[:tmr] if redirect.is_a? Net::HTTPRedirection
			
			render json: { result: result }.as_json
			return
		end

		if response.is_a? Net::HTTPSuccess
			render json: { result: messages[:valid] }.as_json
			return
		end

		# Default to 404.
		return render json: { result: messages[:bad] }.as_json
	end


	private


		def contact_params
			params.permit(:file_name, :full_name, :social_profile_url, :mobile_number)
		end

end
