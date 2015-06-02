require 'uri'

module ApplicationHelper

	def shorti(url)
		domains = ['www.facebook.com', 'twitter.com']
		link = nil

		domains.each do |dom|
			link = "#{dom}#{URI(url).path}" if dom == URI(url).host
		end

		link = link.sub!('www.', '') if /www./.match(link)

		return link.sub!('.com', '') 
	end

end
