class RemoveImageableReferencesFromService < ActiveRecord::Migration
  def change
    remove_reference :services, :imageable, index: true
  end
end
