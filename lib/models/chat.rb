class Chat < OpenStruct
  def initialize(attrs)
    super(attrs.deep_symbolize_keys)
  end

  alias serializable_hash to_h

  def send_message(params)
    Boto.application.adapter.send_message(params.merge(additional_params))
  end

  def send_photo(params)
    Boto.application.adapter.send_photo(params.merge(additional_params))
  end

  def additional_params
    { chat_id: id }
  end
end
