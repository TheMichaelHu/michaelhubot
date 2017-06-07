module Help
  include Sender
  
  def self.hear(sender, message)
    help_message = "Yeah uh...what?"

    Sender.send_message(sender, help_message)
    return true
  end
end