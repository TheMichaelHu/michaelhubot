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
        Listener.handleMessage(sender, text)
      end
    end

    head :ok
  end
end