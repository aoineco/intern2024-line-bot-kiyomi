require 'line/bot'

class WebhookController < ApplicationController
  protect_from_forgery except: [:callback] # CSRF対策無効化

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head 470
    end

    events = client.parse_events_from(body)
    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          if event.message['text'] == 'タスク'
            user_id = event['source']['userId']
            task = ChallengeTask.where(user_id: user_id).order('RANDOM()').first

            # 後で書く→ Flex Messageの作成
	    
	    if task.present?
              message = {type:'text', text: 'タスク：#{task.content'}
            else
              message = {type: 'text', text: '本日のタスクはありません。'}
            end
	    

            client.reply_message(event['replyToken'], message)
          end
      end
    }
    head :ok
  end
end
