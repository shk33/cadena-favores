class RemoveTaggableReferencesFromProfiles < ActiveRecord::Migration
  def change
    remove_reference :profiles, :taggable, index: true
  end
end
