class Status

  def start
    available_statuses = [
      { type: :playing, activity: 'Developed by Dario' },
      { type: :watching, activity: 'Github/Knerio' },
      { type: :listening, activity: 'Spotify' }
    ]

    selected_status = available_statuses[Random.rand(available_statuses.size)]

    case selected_status[:type]
    when :playing
      Bot.playing = selected_status[:activity]
    when :watching
      Bot.watching = selected_status[:activity]
    when :listening
      Bot.listening = selected_status[:activity]
    end
  end

end