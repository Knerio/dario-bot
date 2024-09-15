class ErrorResponse

  def self.default_embed(title: "An error occurred", color: "ff0014", description: nil, **args)
    unless description.nil?
      description = "```#{description}```"
    end
    Discordrb::Webhooks::Embed.new(title: title, color: color, description: description, **args)
  end

  def self.active_model(errors)
    new(default_embed(description: errors.full_messages.join(", ")))
  end

  def self.service_response(response)
    return nil unless response.error?
    if response.payload.is_a? ActiveModel::Errors
      return active_model(response.payload)
    end
    return new(default_embed(description: response.message))
  end

  attr_reader :embed

  def initialize(embed = default_embed)
    @embed = embed
  end

  def respond(event)
    event.respond embeds: [embed]
  end

end