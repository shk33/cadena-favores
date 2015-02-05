class CreateServiceArrangements < ActiveRecord::Migration
  def change
    create_table :service_arrangements do |t|
      t.date :start_date
      t.date :end_date
      t.integer :client_id
      t.integer :server_id
      t.boolean :completed
      
      t.timestamps
    end
  end
end
