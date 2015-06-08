Rails.application.routes.draw do

  root 'contacts#index'

  resources :contacts, only: [:index, :new, :create], defaults: { format: :json } do
  	collection do
  		get 'check_full_name/:full_name', 
  			full_name: /.*/, 
  			action: 'check_full_name', 
  			as: 'check_full_name'
  		
  		get 'check_social_link/:url', 
  			url: /.*/, 
  			action: 'check_social_link', 
  			as: 'check_social_link' 
  	end
  end

end
