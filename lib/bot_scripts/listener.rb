module Listener
  include Bees
  include MBTA

  def self.handleMessage(sender, message)
    included_modules().each do |mod|
      if mod.try(:hear, sender, message)
        return true
      end
    end

    return false
  end
end