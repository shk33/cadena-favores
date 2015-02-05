class CreateRequiredServices < ActiveRecord::Migration
  def change
    create_table :required_services do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
