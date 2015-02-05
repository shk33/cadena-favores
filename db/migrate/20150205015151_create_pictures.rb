class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :imageable, polymorphic: true, index: true
      t.text :route
      t.string :name
      t.timestamps
    end
  end
end
