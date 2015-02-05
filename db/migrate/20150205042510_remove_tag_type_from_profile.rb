class RemoveTagTypeFromProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :taggable_type, :string
  end
end
