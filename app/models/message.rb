class Message < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :chat

  def receiver_user sender_user
    users = self.chat.users
    users = users - [sender_user]
    users[0]
  end
end
