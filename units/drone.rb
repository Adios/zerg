module Zerg

  # the most generic unit among the swarms.
  class Drone < Larva
    def on_success(target, buffer)
      block_given? ? yield(target, buffer) : buffer.read
    end
  end
end

# vim:sts=2 sw=2 expandtab:
