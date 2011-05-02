Zerg
====

Zerg is an event-based lightweight downloader built on [cool.io](http://coolio.github.com/), the Ruby's `libev` binding.
 
Anatomy
----

`Kerrigan`, the successor of the Overmind, governs all the swarms. All Zerg units are mutated from the basic `Larva`, connected with `Kerrigan` via some kind of mind power. 
 
* `Zerg::Larva` - mutate me.
* `Zerg::Drone` - generic download unit.
* `Zerg::Kerrigan` - Queen of Blades.

Requirement
----
 
* [cool.io](http://coolio.github.com/)
  * `gem install cool.io`
* ruby 1.9+

Usage
----

    require 'zerg'
    urls = %w(http://www.google.com http://flickr.com)

To simply get a hash with downloaded contents,

    Zerg.rush(:drone, urls)	# => {:'http://www.google.com.tw/' => ..., :'http://www.flickr.com/' => ... }
    Zerg.drone_rush(urls)	# => the same as above.

Specify the amount of concurrent working units,

    Zerg.drone_rush(urls, :amount => 3)	# => 3 drones rush at a time, default is 5.

Save content to a file whenever completing a request,

    require 'uri'

    Zerg.drone_rush(urls) do |target, buffer|
      # target: Symbol
      # buffer: IO::Buffer

      buffer.write_to(File.new(URI(target.to_s).host, 'w'))
    end

Create Your Units
----
 
Just create a new class inherit from `Zerg::Larva`, puts them under the `units/`, for example `units/queen.rb`: 
 
    module Zerg
      class Queen < Larva
        # your methods here.
      end
    end

and you can use `Zerg.queen_rush` in your codes.
