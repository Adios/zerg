module Zerg

  # the center of all the zerg swarms,
  # the successor of the dead Overmind.
  class Kerrigan
    def initialize(unit, pool, options = {})
      @unit, @pool, @data = unit, pool, {}

      @options = {
        log: Logger.new(STDERR),
        amount: 5,
        user_agent: 'ZERG/0.0 (ZERG ruins the world!)'
      }.merge!(options).freeze

      @event_loop = prepare_event_loop
    end

    class << self; alias :control :new end

    # battle strategy, receive the responses from all the zerg units.
    def attack(&block)
      while zerg = @event_loop.resume
        case target = zerg.target and status = zerg.header.status
        when 200
          @data[target] = zerg.on_success(target, zerg.stomach, &block)
        when 302
          @pool << zerg.header['LOCATION']
        else
          @options[:log].info '%s: %s' % [target, status]
        end

        unit_attack
      end

      @data
    end

    private

    def prepare_event_loop
      Fiber.new do
        @options[:amount].times { unit_attack }
        Coolio::Loop.default.run
      end
    end

    def unit_attack
      url = @pool.next or return

      u = URI(url)

      @unit
      .connect(u.host, u.port, u.normalize.to_s)
      .attach(Coolio::Loop.default)
      .request('GET', u.request_uri, head: {'user-agent' => @options[:user_agent]})
    end
  end
end

# vim:sts=2 sw=2 expandtab:
