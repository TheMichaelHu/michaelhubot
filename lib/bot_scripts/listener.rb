module Listener
  include Bees
  include MBTA
  include Sender

  def self.handleMessage(sender, message)
    Sender.send_typing_action(sender, true)
    included_modules().each do |mod|
      if mod.try(:hear, sender, message)
        Sender.send_typing_action(sender, false)
        return true
      end
    end

    Sender.send_typing_action(sender, false)
    return false
  end
end