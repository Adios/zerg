module Zerg

  # all units are mutated from Larva.
  class Larva < Coolio::HttpClient
    attr_reader :target, :header, :stomach

    def initialize(socket, url)
      super socket

      @target = url.to_sym
      @stomach = ::IO::Buffer.new
    end

    def on_success(target, buffer); end

    protected

    def on_response_header(header)
      @header = header
    end

    def on_body_data(data)
      @stomach << data
    end

    def on_request_complete
      Fiber.yield self
      super
    end

    # capture successful HTTP responses those set
    # neither content-length nor chunked transfer coding
    # (e.g.: http://www.google.com),
    # they won't trigger on_request_complete.
    def on_close
      Fiber.yield self if @bytes_remaining.nil? and not @stomach.empty?
      super
    end
  end
end

# vim:sts=2 sw=2 expandtab:
