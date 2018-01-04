module Clients
  class Web < Foxy::Client
    attr_reader :url
    attr_reader :rate_limit

    def initialize(url:, rate_limit:, response_class:)
      @url = url
      @rate_limit = rate_limit
      @response_class = response_class
      super
    end

    def fetch_flats(url)
      eraw(path: url, class: @response_class).flats
    end
  end
end