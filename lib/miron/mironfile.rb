module Miron
  class Mironfile
    # Returns the contents of the Mironfile in the given dir, if any exists.
    #
    # @param  [Pathname] dir
    #         The directory where to look for the Mironfile.
    #
    # @return [Miron::Mironfile] Returns newly create {Miron::Mironfile}
    # @return [Nil] If no Mironfile was found in the given dir
    #
    attr_reader :app

    def self.from_dir(dir)
      path = dir + 'Mironfile'
      mironfile = Mironfile.new do
        eval(path.read, nil, path.to_s)
      end
      mironfile
    end

    def initialize(&block)
      instance_eval(&block)
    end

    # Takes an argument that is an object that responds to #call and returns a {Miron::Response}.
    #
    #   class Heartbeat
    #     def self.call(request)
    #      Miron::Response.new(200, { "Content-Type" => "text/plain" }, "OK")
    #     end
    #   end
    #
    #   run Heartbeat
    def run(app)
      @app = app
    end
  end
end
