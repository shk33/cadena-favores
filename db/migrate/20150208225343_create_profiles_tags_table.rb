class CreateProfilesTagsTable < ActiveRecord::Migration
  def change
    create_table :profiles_tags, id: false do |t|
      t.belongs_to :tag,  index: true
      t.belongs_to :profile, index: true
    end
  end
end
