class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.references :user, index: true
      t.references :required_service, index: true

      t.timestamps
    end
  end
end
