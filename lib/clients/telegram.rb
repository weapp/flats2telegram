module Clients
  class Telegram < Foxy::Client
    def rate_limit
      2
    end

    def updates
      Enumerator.new do |enum|
        update_id = 0
        loop do
          updates = get_updates(update_id)
          update_id = updates[:result].last[:update_id] + 1 if updates[:result].last
          updates[:result].each { |update| enum << update[:message] }
          enum << nil
        end
      end.lazy
    end

    def url
      "https://api.telegram.org/bot#{ENV['TELEGRAM_TOKEN']}/"
    end

    def get_me
      json(path: "getMe")
      # cache.yaml("getMe") { json(path: "getMe") }.deep_symbolize_keys
    end

    def get_updates(offset)
      # cache.yaml("telegram-updates", offset) {
        json(path: "getUpdates", params: { offset: offset }).deep_symbolize_keys
      # }
    end

    def send_message(params)
      json(path: "sendMessage", params: params)
    end

    def send_photo(params)
      json(path: "sendPhoto", params: params)
    end
  end
end
