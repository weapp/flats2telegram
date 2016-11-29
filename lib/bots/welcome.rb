class Welcome < ApplicationBot
  def log
    history_for(Repositories::User, current_user)
    history_for(Repositories::Chat, current_chat)

    puts OpenStruct.new(update).instance_eval {
          "#{Time.at(date).strftime("%Y-%m-%d %H:%M")} (#{message_id}) " \
          "#{from[:first_name]} (@#{from[:username]}) " \
          "at `#{chat[:title] || chat[:type]}`:\n#{text || self}"
    }
  end

  def hello
    current_chat.send_message text: "hello #{current_user.first_name}!"
  end

  def echo
    current_chat.send_message text: message[:text].split(" ", 2).last
  end

  def history_for(repo, model)
    model.history ||= [] << update
    model.history.slice!(0, model.history.size - 50)
    repo.new.save(model)
  end
end
