require 'boto/bot'

class ApplicationBot < Boto::Bot
  def current_user
    @current_user ||= Repositories::User.new.find_or_create(message[:from])
  end

  def current_chat
    @current_chat ||= Repositories::Chat.new.find_or_create(message[:chat])
  end

  def me
    Repositories::User.new.find_or_create(Boto.application.adapter.get_me[:result])
  end

  alias user current_user
  alias chat current_chat
  alias update env
  alias message env
end
