class WebhooksController < ApplicationController
  def challenge
    if params['hub.verify_token'] == 'michael_hu_bot_is_not_hubot'
      render text: params['hub.challenge']
    else
      render text: 'Error, wrong validation token'   
    end
  end
end
