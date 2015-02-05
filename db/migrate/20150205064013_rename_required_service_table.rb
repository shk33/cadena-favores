class RenameRequiredServiceTable < ActiveRecord::Migration
   def change
     rename_table :required_services, :service_requests
   end 
end
