module Bees
  include Sender
  
  def self.hear(sender, message)
    gifs = [
      "http://i.imgur.com/O1m6NtH.jpg",
      "https://media.giphy.com/media/dcubXtnbck0RG/giphy.gif",
      "https://media.giphy.com/media/SRKQ1Y0TB4n1m/giphy.gif",
      "https://media.giphy.com/media/NdNvP45BfLNxC/giphy.gif",
      "https://media.giphy.com/media/lY0rvSQjTv8ME/giphy.gif",
      "https://media.giphy.com/media/qsCxYSO0VaMHm/giphy.gif"
    ]

    if /bees/i.match(message)
      Sender.send_gif(sender, gifs.sample)
      return true
    end
    
    return false
  end
end