class RemoveImageTypeFromService < ActiveRecord::Migration
  def change
    remove_column :services, :imageable_type, :string
  end
end
