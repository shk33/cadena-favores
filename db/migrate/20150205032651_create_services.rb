class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :title
      t.text :description
      t.integer :cost
      t.references :service_arrangement, index: true

      t.timestamps
    end
  end
end
