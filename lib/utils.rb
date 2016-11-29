module FileUtils
  def makedir_p(tokens)
    1.upto(tokens.size) do |n|
      dir = tokens[0...n].join("/")
      Dir.mkdir(dir) unless Dir.exist?(dir)
    end
  end

  module_function :makedir_p
end
