class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :chat, index: true
      t.string :author
      t.text :text

      t.timestamps
    end
  end
end
