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
    attr_reader :app, :middleware

    def self.from_dir(dir)
      path = dir + 'Mironfile.rb'
      from_file(path)
    end

    # Returns the contents of the Mironfile in the given path.
    #
    # @param  [Pathname] path
    #         The path for the Mironfile.
    #
    # @return [Miron::Mironfile] Returns newly create {Miron::Mironfile}
    # @return [Nil] If no Mironfile was found in the given dir
    #
    def self.from_file(path)
      return nil unless path && File.exist?(path)
      mironfile = new(path)
      mironfile.evaluate
      mironfile
    end

    def initialize(mironfile_path)
      @mironfile_path = mironfile_path
      @middleware = []
    end

    # Takes an argument that is an object that responds to #call and returns a {Miron::Response}.
    #
    #   If you want to provide parameters besides for request and response to your app, you can do
    #   this too! See the below example for more information.
    #
    #   class Heartbeat
    #     def initialize(hi)
    #       @hi = hi
    #     end
    #
    #     def call(request, response)
    #       response.http_status = 200
    #       response.headers = { "Content-Type" => "text/plain" }
    #       response.body = @hi
    #     end
    #   end
    #
    #   run Heartbeat, 'hi'
    #
    def run(app_constant, *args)
      if args.empty?
        @app = app_constant.new
      else
        @app = app_constant.new(args)
      end
    end

    # Takes an argument that is an object that responds to #call and returns a {Miron::Response}.
    #
    #   If you want to provide parameters besides for request and response to your middleware, you can do
    #   this too! See the below example for more information.
    #
    #   class Middle
    #     def initialize(hi)
    #       @hi = hi
    #     end
    #
    #     def call(request, response)
    #       puts @hi
    #     end
    #   end
    #
    #   class Heartbeat
    #     def call(request, response)
    #       response.http_status = 200
    #       response.headers = { "Content-Type" => "text/plain" }
    #       response.body = @hi
    #     end
    #   end
    #
    #   use Middle, 'hi'
    #   run Heartbeat
    #
    def use(middleware_constant, *args)
      if args.empty?
        @middleware << middleware_constant.new
      else
        @middleware << middleware_constant.new(args)
      end
    end

    # Evaluates the Mironfile provided.
    def evaluate
      instance_eval(@mironfile_path.read)
    end
  end
end
