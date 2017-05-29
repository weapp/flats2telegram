#!/usr/bin/env ruby

%w(logger json ostruct yaml/store bundler/setup).each(&method(:require))

Bundler.require(:default, ENV["APP_ENV"] || "development")
Dir[File.dirname(__FILE__) + "/lib/**/*.rb"].sort.each { |file| require file }
Dotenv.load

class Store
  def self.store
    @store ||= YAML::Store.new "store.yaml"
  end

  def self.visited
    store.transaction do
      store["visited"] ||= []
    end
  end

  def self.visited= value
    store.transaction do
      store["visited"] = value
    end
  end
end

class App
  def self.config
    @_config = YAML.load_file('config.yml')
  end

  def self.sites_config
    @_sites_config = config['sites']
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.debug(obj)
    Pry::ColorPrinter.pp(obj)
    obj
  end

  def self.env
    ENV["APP_ENV"] || "development"
  end

  def self.pb(total=100)
    @pb ||= ProgressBar.create format: "%a |%b>%i| %P% (%c/%C)",
                               total: total
  end

  def self.telegram
    @telegram ||= Clients::Telegram.new
  end

  def self.run(site)
    puts "fetching #{Time.now} #{site}!"
    config = sites_config[site]
    client = Clients::Web.new(url: config['url'],
                              rate_limit: config['rate_limit'],
                              response_class: Object.const_get("FlatsResponse::#{site.capitalize}"))

    config['search_paths'].each do |url|
      send_flats(client.fetch_flats(url))
    end

  rescue => e
    puts "#{Time.now}: fail! #{e}"
  end

  def self.send_flats(flats)
    p flats.map { |flat| flat[:id] }

    send_message("#{Time.now}: Doesn't work: #{site.class.name}!", false) if flats.count == 0

    flats.each do |flat|
      next if Store.visited.include?(flat[:id])
      Store.visited = (Store.visited << flat[:id]).uniq
      flat = OpenStruct.new(flat)
      App.debug send_message("*#{flat.title}*\n#{flat.details}\n\n#{flat.desc}\n\n#{flat.href}".gsub("\n\n\n\n", "\n\n"), flat[:md])
    end
  end

  def self.send_message(text, md)
    msg_attrs = {text: text, chat_id: config['chat_id']}
    msg_attrs[:parse_mode] = 'Markdown' if md

    telegram.send_message(msg_attrs)
  end

  def self.run!
    loop do
      run('idealista')
      run('fotocasa')
      # run(enalquiler)
      sleep(30)
    end
  end

  def self.list_hash
    Hash.new { |hash, key| hash[key] = [] }
  end

  def self.html(html)
    source = HtmlBeautifier.beautify html.to_s
    formatter = Rouge::Formatters::Terminal256.new#(theme: 'monokai')
    lexer = Rouge::Lexers::HTML.new
    puts formatter.format(lexer.lex(source))
  end
end

# App.run! if __FILE__ == $PROGRAM_NAME
App.run!(*ARGV) if __FILE__ == $PROGRAM_NAME
