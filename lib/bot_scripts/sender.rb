module Sender
  def self.send_message(recipient, text)
    message_data = {text: text}
    data = {recipient: {id: recipient}, message: message_data}.to_json
    
    uri = URI.parse("https://graph.facebook.com/v2.6/me/messages?access_token=#{ENV['ACCESS_TOKEN']}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.request_uri)
    request.content_type = 'application/json'
    request.body = data
    response = http.request(request)
  end

  def self.send_gif(recipient, gif)
    message_data = {
      attachment: {
        type: "image", 
        payload: {
          url: gif
        }
      }
    }
    data = {recipient: {id: recipient}, message: message_data}.to_json
    
    uri = URI.parse("https://graph.facebook.com/v2.6/me/messages?access_token=#{ENV['ACCESS_TOKEN']}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.request_uri)
    request.content_type = 'application/json'
    request.body = data
    response = http.request(request)
  end

  def self.send_typing_action(recipient, typing_on)
    sender_action = typing_on ? "typing_on" : "typing_off"
    data = {recipient: {id: recipient}, sender_action: sender_action}.to_json
    
    uri = URI.parse("https://graph.facebook.com/v2.6/me/messages?access_token=#{ENV['ACCESS_TOKEN']}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.request_uri)
    request.content_type = 'application/json'
    request.body = data
    response = http.request(request)
  end
end