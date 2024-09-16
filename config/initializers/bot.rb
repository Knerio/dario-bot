require 'discordrb'
# Bot token and other configurations
PREFIX = '!'

return if ENV.fetch("DISCORD_BOT_TOKEN", nil).nil?

Bot = Discordrb::Commands::CommandBot.new prefix: PREFIX, token: ENV.fetch("DISCORD_BOT_TOKEN"), intents: :unprivileged

Dir["#{Rails.root}/app/discord/**/*.rb"].each do |file|
  puts "Requiring #{file}"
  require file
end

# Start the bot
Bot.run(true)