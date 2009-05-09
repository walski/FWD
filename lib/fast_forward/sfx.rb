module FWD
  class SFX < Gosu::Sample
    def initialize(file)
      super(window, FWD::Util.matching_file("media/sfx/#{file}", ['wav']))
    end
  end
end