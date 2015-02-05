class RemoveImageableReferencesFromProfiles < ActiveRecord::Migration
  def change
    remove_reference :profiles, :imageable, index: true
  end
end
