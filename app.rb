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

  def self.idealista
    @idealista ||= Clients::Idealista.new
  end

  def self.fotocasa
    @fotocasa ||= Clients::Fotocasa.new
  end

  def self.enalquiler
    @fotocasa ||= Clients::EnAlquiler.new
  end

  def self.telegram
    @telegram ||= Clients::Telegram.new
  end

  def self.run(site)
    puts "fetching #{Time.now} #{site.class.name}!"
    flats = site.flats
    p flats.map { |flat| flat[:id] }

    # flats.map { |flat| Store.visited = (Store.visited << flat[:id]).uniq }
    # p Store.visited

    send_message("#{Time.now}: Doesn't work: #{site.class.name}!") if flats.count == 0

    flats.map do |flat|
      next if Store.visited.include?(flat[:id])
      Store.visited = (Store.visited << flat[:id]).uniq
      flat = OpenStruct.new(flat)
      App.debug send_message("*#{flat.title}*\n\n#{flat.details}\n\n#{flat.desc}\n\n#{flat.phones}\n\n#{flat.href}", flat[:md])
    end

  rescue => e
    puts "#{Time.now}: fail! #{e}"
  end

  def self.send_message(text, md)
    if md
      telegram.send_message(
        text: text,
        chat_id: 7298790,
        parse_mode: "Markdown"
      )
    else
      telegram.send_message(
        text: text,
        chat_id: 7298790
      )
    end
  end

  def self.run!
    loop do
      run(idealista)
      run(fotocasa)
      run(enalquiler)
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
