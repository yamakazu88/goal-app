class GoalsController < ApplicationController
  protect_from_forgery except: [:callback]

  def index
  end

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)    #LINE以外からのアクセスの場合、エラーを返す
      return head :bad_request
    end

    events = client.parse_events_from(body)       #送られてきたメッセージデータをeventsというデータ構造に変更
    events.each do |event|
      case event
      when Line::Bot::Event::Message              #eventがメッセージだったら
        case event.type
        when Line::Bot::Event::MessageType::Text  #メッセージのタイプがテキストだったら
          
          #目標設定機能（始まり）
          case event[ 'message'][ 'text']
          when "目標設定"                          #メッセージが「目標設定」だったとき
            message = {
              type: 'text',
              text: "目標を入力してください！"
            }
            client.reply_message(event['replyToken'], message)
          end

          events = client.parse_events_from(body)                   #入力された目標を含んだメッセージデータをeventsというデータ構造に変更
          events.each do |event|
            case event
            when Line::Bot::Event::Message
              case event.type
              when Line::Bot::Event::MessageType::Text
                goal = event[ 'message'][ 'text']            #メッセージの文字列を取得して変数goalに代入

                begin
                Goal.create!(goal: goal)                             #メッセージの文字列をタスクテーブルに登録
                  message = {
                    type: 'text',
                    text: "目標『#{goal}』を設定しました！"
                  }
                  client.reply_message(event['replyToken'], message)  #設定が成功したらその旨を返す
                
                rescue 
                  message = {
                    type: 'text',
                    text: "目標『#{goal}』の設定に失敗しました。"
                  }
                  client.reply_message(event['replyToken'], message)    #設定が失敗したらその旨を返す
                end
              end
            end
          end
          #目標設定機能（終わり）
        end
      end
      head :ok
    end
    

  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end