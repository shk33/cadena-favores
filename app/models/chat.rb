class Chat < ActiveRecord::Base
  has_many  :chat_rooms
  has_many  :messages
  has_many  :users, through: :chat_rooms
end
