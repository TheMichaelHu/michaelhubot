class WebhooksController < ApplicationController
  @token = 'CAAZA2hSIX2LABAFCYquGFQ5Tz5aJXfTNEuSvdGtZBRkJnoM81F4HzWF0FSMMsbUn5PIboxu0pvqwlYD4RU0bRIJgk6ahR6ulgCzanZA80kClpKlk5eVuqsTUZCBKsZCHGIgrPUPuYuBGXe6dVZCGThAa9ZC2SLZBuuZAtufuTV6rmNUB72yZADZA3e8MvoBZCvuos3gZD'
  
  def challenge
    if params['hub.verify_token'] == 'michael_hu_bot_is_not_hubot'
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
    data = {qs: {access_token: @token},
            json: {recipient: {id: recipient}, message: message_data}}
    Net::HTTP.post_form(URI.parse("https://graph.facebook.com/v2.6/me/messages"), data)
  end
end
