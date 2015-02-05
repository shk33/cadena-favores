class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user, index: true
      t.references :service_arrangement, index: true
      t.integer :rating
      t.text :description

      t.timestamps
    end
  end
end
