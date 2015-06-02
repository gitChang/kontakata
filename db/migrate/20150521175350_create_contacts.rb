class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
    	t.string :file_name
      t.string :full_name
      t.string :social_profile_url
      t.string :mobile_number

      t.timestamps null: false
    end
  end
end
