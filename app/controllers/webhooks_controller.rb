class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:message]

  def challenge
    if params['hub.verify_token'] == ENV['VERIFY_TOKEN']
      render text: params['hub.challenge']
    else
      render text: 'Error, wrong validation token'   
    end
  end

  def message
    messaging_events = params[:entry][0][:messaging]
    messaging_events.each do |event|
      sender = event[:sender][:id]
      if event[:message] && event[:message][:text]
        text = event[:message][:text]
        send_message(sender, text)
      end
    end

    head :ok
  end

  private

  def send_message(recipient, text)
    message_data = {text: text}
    data = {access_token: ENV['ACCESS_TOKEN'], recipient: recipient, message: text}
    
    uri = URI.parse("https://graph.facebook.com/v2.6/me/messages")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.request_uri)
    request.content_type = 'application/json'
    request.set_form_data data
    puts request
    response = http.request(request)
    puts response
  end
end