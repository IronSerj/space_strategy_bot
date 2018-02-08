class Client
  WELCOME = 'welcome'
  PING = 'ping'
  CONFIRM_SUBSCRIPTION = 'confirm_subscription'

  class ConnectionIsLostError < StandardError; end

  def initialize(bot)
    @bot = bot
  end

  def run
    EM.run do
      ws = WebSocket::EventMachine::Client.connect(
        uri: APPLICATION_SETTINGS['server']['url'],
        headers: { 'Cookie' => "actioncable_auth_token=#{APPLICATION_SETTINGS['auth_token']}" })

      ws.onopen do
        puts "Connection established..."
      end

      ws.onclose do
        puts "Connection is lost, trying to reconnect..."
        raise ConnectionIsLostError
      end

      ws.onmessage do |msg, type|
        hash = Oj.load(msg)
        case hash['type']
        when WELCOME
          ws.send Oj.dump({ "command" => "subscribe", "identifier" => "{\"channel\":\"GameChannel\"}" })
        when CONFIRM_SUBSCRIPTION
          puts "System is ready..."
        when PING
        else
          puts "Received: #{hash['message']}"
          ws.send Oj.dump(@bot.move(hash['message']))
        end
      end
    end
  end
end
