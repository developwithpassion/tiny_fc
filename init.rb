require 'bundler'
Bundler.setup

#core custom gems
require 'initializer'
require 'single'
require 'settings'

#update load paths
[
 '../config',
 '../lib',
].each do |path|
  dir = File.expand_path(path, __FILE__)
  $LOAD_PATH.unshift dir unless $LOAD_PATH.include?(dir)
end

require 'tiny_fc'
