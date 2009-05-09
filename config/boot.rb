FWD_ROOT = File.dirname(File.dirname(__FILE__) + '../')
$LOAD_PATH << "#{FWD_ROOT}/lib/fast_forward"
$LOAD_PATH << "#{FWD_ROOT}/game/objects"

require "rubygems"
require "gosu"

require "fast_forward"