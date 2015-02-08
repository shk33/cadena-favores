class CreateServiceRequestsTags < ActiveRecord::Migration
  def change
    create_table :service_requests_tags do |t|
      t.belongs_to :tag,  index: true
      t.belongs_to :service_request, index: true
    end
  end
end
