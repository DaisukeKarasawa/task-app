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

    def validate_deadline(deadline)
        month = deadline / 100
        day = (deadline % 100 ) / 1

        return "#{month}月#{day}日"
    end

    def checkDeadline(day)
        currentDate = Date.today
        month = day / 100
        day = (day % 100) / 1

        deadline = Date.new(currentDate.year, month, day)

        if deadline > currentDate
            remain = (deadline - currentDate).to_i
            message = "残り#{remain}日"
        else
            message = "締め切りは過ぎています。"
        end
        message
    end
    
    # テキストの返信
    def response_message_event(text)
        if text.include?("登録")
            subject, deadline = text.delete('登録').delete("\n").split('、')
            unless subject.present? || deadline.present?
                message = {
                    type: 'text',
                    text: "登録情報を記述して下さい。\n記述例：英語、0101"
                }
                return message
            end

            day = deadline.length == 4 ? validate_deadline(deadline.to_i) : nil
            if day.nil?
                message = {
                    type: 'text',
                    text: "締め切りは四桁で入力して下さい。\n例：0101" 
                }
            else
                task = Task.create!(title: subject, deadline: deadline.to_i)
                message = {
                    type: 'text',
                    text: "#{subject}の締め切りを、#{day}で登録しました。"
                }
            end
        elsif text.include?("一覧")
            tasks = Task.all

            if tasks.present?
                taskList = tasks.map { |task| "・#{task.title}: #{validate_deadline(task.deadline)} (#{checkDeadline(task.deadline)})" }.join("\n")
                message = "タスク一覧:\n#{taskList}"
            else
                message = "タスクがありません"
            end
            message = {
                type: 'text',
                text: message
            }
        else
            message = {
                type: 'text',
                text: "期限の登録であれば「登録」、一覧の取得であれば「一覧」の文字を必ず入力して下さい。\n\n期限の登録であれば「登録」の後に「科目、日付」の形式で入力してください。"
            }
        end
        
        message
    end
end
