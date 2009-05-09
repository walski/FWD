module FWD
  # Configuration class for FFD games. 
  # Use it like this in the config/game.rb:
  # FWD::Config.some_attribute = 100
  # FWD::Config.some_attribute.another_attribute = 'Hallo'
  #
  # You can access the configuration later through the FWD::Game class:
  # puts FWD::Game.config.some_attribute # => 100
  class Config
    def self.method_missing(method_name, *attributes)
      @config ||= Hash.new 
      
      if method_name.to_s =~ /=$/ && attributes.size == 1
        @config[method_name.to_s[0...-1].to_sym] = attributes.first 
      end
      
      @config[method_name]
    end
  end
end