require 'net/http'
require 'uri'

class Contact < ActiveRecord::Base

  after_validation :verify_file_type
  after_validation :verify_social_profile_url
  before_save      :titleize_full_name


  RE_FULLNAME  = /\A[a-zA-Z .]+\z/
  RE_SOCIALURL = /\A#{URI::regexp(%w(http https))}\z/
  RE_MOBILENUM = /\A[0-9-]+\z/

  validates :file_name, 
    presence: { 
      message: 'Please select a Photo.' 
    }

  validates :full_name, 
    presence: { 
      message: 'Please type your Full Name.' 
    },
    format: { 
      with: RE_FULLNAME, 
      message: 'Unacceptable Name.' 
    },
    uniqueness: { 
      case_sensitive: false, 
      message: 'Name already exists.', 
      on: :create 
    }

  validates :social_profile_url, 
    presence: { 
      message: 'Please specify Social Profile URL.' 
    },
    format: { 
      with: RE_SOCIALURL, message: 'Invalid Social Profile URL.' 
    }

  validates :mobile_number, 
    presence: { 
      message: 'Please type your Mobile Number.' 
    },
    format: { 
      with: RE_MOBILENUM, message: 'Unacceptable Mobile Number.' 
    }



  # triggered on ajax request
  # for full name duplicates.
  def self.full_name_exists?(full_name)
    where('lower(full_name) = ?', full_name.downcase).size > 0
  end


  # checks the existence of
  # the social profile url.
  def self.verify_url(url)
    allowed_domain = %w(www.facebook.com twitter.com)
    
    return false unless url =~ RE_SOCIALURL
    return false if URI(url.to_s).path.empty?
    return false unless allowed_domain.include?(URI(url).host)

    response = Net::HTTP.get_response(URI(url))

    if response.is_a? Net::HTTPSuccess
      return true
    else
      return false
    end
  end


  private


    # callback for file_name.
    # check if file is an image.
    def verify_file_type
      if file_name
        allowed_types = %w(jpeg jpg png gif)

        unless allowed_types.include? file_name.split('.')[1]
          errors.add(:file_name, 'File is not an image.')
        end
      end
    end


    # callback for social profile
    # url validation.
    def verify_social_profile_url
      unless Contact.verify_url(social_profile_url)
        errors.add(:social_profile_url, 'Invalid Social Profile URL.')
      end
    end


    # before_save callback to reformat
    # character casing of full name field.
    def titleize_full_name
      self.full_name = full_name.titleize
    end 

end
