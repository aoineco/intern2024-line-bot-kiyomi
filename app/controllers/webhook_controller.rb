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
      task = ChallengeTask.order('RANDOM()').first
      case event.type
      when Line::Bot::Event::MessageType::Text
        if event.message['text'] == 'タスク'
          message = {
            type:'flex',
            altText:'今回のタスク',
            contents:flex_message
            
          }
          message[:contents][:body][:contents] << {
            type:'text',
            text:task.content,
            align:'center'
          }

          client.reply_message(event['replyToken'], message)
        end
      
      end

      when Line::Bot::Event::Postback
        case event['postback']['data']
        when 'complete'
          message = {
            type:'text',
            text:"タスクを達成しました！\nおめでとうございます！！"
          }
          client.reply_message(event['replyToken'], message)
        when 'incomplete'
          message = {
            type:'text',
            text:"タスクは達成されませんでした…。\nそんな日もあります\n次はがんばりましょう！"
          }
          client.reply_message(event['replyToken'], message)
      end
    end
  }
  head :ok
  end

  def flex_message
    {
      "type": "bubble",
      "header": {
        "type": "box",
        "layout": "vertical",
        "contents": [
          {
            "type": "text",
            "text": "今回のタスク",
            "weight": "bold",
            "size": "xl",
            "align": "center"
          }
        ]
      },
      "body": {
        "type": "box",
        "layout": "vertical",
        
        "contents": []
      },
      "footer": {
        "type": "box",
        "layout": "vertical",
        "spacing": "sm",
        "contents": [
          {
            "type": "button",
            "style": "link",
            "height": "sm",
            "action": {
              "type": "postback",
              "label": "できた！",
              "data": "complete"
            }
          },
          {
            "type": "button",
            "style": "link",
            "height": "sm",
            "action": {
              "type": "postback",
              "label": "ダメだった…",
              "data": "incomplete"
            }
          },
          {
            "type": "box",
            "layout": "vertical",
            "contents": [],
            "margin": "sm"
          }
        ],
        "flex": 0
      }
    }
  end
end
