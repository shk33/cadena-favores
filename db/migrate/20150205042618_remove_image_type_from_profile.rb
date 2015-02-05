class RemoveImageTypeFromProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :imageable_type, :string
  end
end
