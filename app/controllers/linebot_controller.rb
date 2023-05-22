class LinebotController < ApplicationController
    require 'line/bot'

    def callback
        # リクエストの読み取り
        body = request.body.read
        signature = request.env['HTTP_X_LINE_SIGNATURE']
        unless client.validate_signature(body, signature)
            render plain: 'Bad Request', status: 400
            return
        end

        events = client.parse_events_from(body)

        events.each do |event|
            case event
            when Line::Bot::Event::Message
                case event.type
                when Line::Bot::Event::MessageType::Text
                    client.reply_message(event['replyToken'], response_message_event(event.message['text']))
                end
            end
        end

        head :ok
    end
    
    private
    
    # クライアントの作成
    def client
        @client ||= Line::Bot::Client.new { |config|
            config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
            config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
        }
    end
    
    # テキストの返信
    def response_message_event(text)
        if text.include?("登録")
            message = TaskCreateService.task_register(text)
        elsif text.include?("一覧")
            message = TasksService.task_list
        elsif text.include?("削除")
            message = TaskDeleteService.task_delete(text)
        elsif text.include?("更新")
            message = TaskUpdateService.task_update(text)
        else
            message = "期限の登録であれば「登録」\n一覧の取得であれば「一覧」\nタスクの削除であれば「削除」\nタスクの更新であれば「更新」\nの文字を必ず入力して下さい。\n\nタスクと締め切り日時は「タスク、日付」の形式で入力してください。"
        end

        {
            type: 'text',
            text: message
        }
    end
end
