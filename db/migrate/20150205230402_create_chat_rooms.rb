class CreateChatRooms < ActiveRecord::Migration
  def change
    create_table :chat_rooms do |t|
      t.references :chat, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
