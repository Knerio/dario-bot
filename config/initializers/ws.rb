URL= "wss://irc-ws.chat.twitch.tv"

TOKEN= 'oauth:rvjqafb569un4juacfutua461asoks'
NICKNAME= 'dopalos'
CHANNEL = 'dopalos_'

def on_streamer_live
  puts "Streamer is live!"
  # Trigger any other functionality you want here
end

def listen_to_twitch
  EM.run do
    ws = Faye::WebSocket::Client.new(URL)

    ws.on :open do |event|
      puts "Connected to Twitch IRC WebSocket"


      ws.send("PASS #{TOKEN}")
      ws.send("NICK #{NICKNAME}")
      ws.send("JOIN ##{CHANNEL}")

      puts "Joined ##{CHANNEL}"
    end

    ws.on :message do |event|
      message = event.data
      puts "Received: #{message}"

      if message.include?('USERNOTICE')
        if message.include?('submysterygift')
          on_streamer_live
        end
      end
    end

    ws.on :close do |event|
      puts "Disconnected from Twitch IRC"
      EM.stop
    end
  end
end

p "Starting to listen"
listen_to_twitch