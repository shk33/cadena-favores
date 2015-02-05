class AddOpenToServiceRequests < ActiveRecord::Migration
  def change
    add_column :service_requests, :open, :boolean, :default => true
  end
end
