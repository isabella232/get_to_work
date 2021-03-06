require "yaml"
require "singleton"

module GetToWork
  class ConfigFile
    attr_reader :data
    include Singleton

    def initialize
      setup_data(self.class.path)
    end

    def setup_data(path)
      @data = begin
                YAML.load_file(path)
              rescue Errno::ENOENT
                {}
              end
    end

    def [](key)
      @data[key]
    end

    def []=(key, value)
      @data[key] = value
    end

    def self.save
      instance.save
    end

    def save
      File.open(self.class.path, "w") { |f| f.write YAML.dump(@data) }
    end

    def self.exist?
      File.exist? path
    end

    def self.path
      File.join(Dir.pwd, filename)
    end

    def self.filename
      ".get-to-work"
    end
  end
end
