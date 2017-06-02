module MBTA
  include Sender
  
  def self.hear(sender, message)

    if /mbta/i.match(message)
      Sender.send_message(sender, message)
      return true
    end
  end
end