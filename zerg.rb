$LOAD_PATH << File.dirname(__FILE__)

require 'logger'
require 'uri'

require 'cool.io'

require 'kerrigan'
require 'larva'

module Zerg

  Dir.glob(File.dirname(__FILE__) + '/units/*.rb').each do |name|
    autoload File.basename(name, '.rb').to_sym.capitalize, name
  end

  def rush(name, urls, options = {}, &block)
    unit = const_get name.to_sym.capitalize
    pool = MultiLevelQueue.new(urls)

    Kerrigan.control(unit, pool, options).attack(&block)
  end

  def method_missing(method, *arguments, &block)
    method =~ /(\w+)_rush/ ? rush($1, *arguments, &block) : super
  end

  extend self

  class MultiLevelQueue < Enumerator
    def initialize(urls)
      urls = urls.to_enum unless urls.respond_to? :next

      @revisit_queue = []

      super() do |y|
        loop { y << urls.next }
        loop { y << @revisit_queue.shift }
      end
    end

    def <<(url)
      @revisit_queue << url
    end
  end
end

if __FILE__ == $0
  urls = %w(http://adios.tw http://flickr.com http://2ch.net http://www.google.com).shuffle!

  p Zerg.larva_rush(urls)
  p Zerg.drone_rush(urls, amount: 1).map{|k, v| '%s: %d' % [k, v.size]}
  Zerg.drone_rush(urls, amount: 10) {|target, buffer|
    puts "#{target.to_s}: #{buffer.size}"
  }
end

# vim:sts=2 sw=2 expandtab:
