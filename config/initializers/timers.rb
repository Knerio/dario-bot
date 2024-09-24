Rails.application.config.after_initialize do
  Thread::new do
    while true
      sleep 3
      Dir["#{Rails.root}/app/discord/timer/*.rb"].each do |file|
        class_name = File.basename(file, ".rb").split('_').map(&:capitalize).join

        Object.const_get(class_name).new.start
      end
    end
  end
end