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
      mironfile = Mironfile.new(path) do
        eval(path.read, nil, path.to_s)
      end
      mironfile
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
      mironfile = Mironfile.new(path) do
        eval(path.read, nil, path.to_s)
      end
      mironfile
    end

    def initialize(mironfile_path, &block)
      require_relative File.expand_path(mironfile_path, __FILE__)
      @middleware = []
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
    def run(app, *args)
      app_constant = app.to_s.gsub!('Miron::Mironfile::', '').constantize
      if args.empty?
        @app = app_constant
      else
        @app = app_constant.new(args)
      end
    end

    # Takes an argument that is an object that responds to #call and returns a {Miron::Response}.
    #
    #   class Middle
    #     def self.call(request)
    #       puts "hello from middle"
    #     end
    #   end
    #
    #   class Heartbeat
    #     def self.call(request)
    #      Miron::Response.new(200, { "Content-Type" => "text/plain" }, "OK")
    #     end
    #   end
    #
    #   use Middle
    #   run Heartbeat
    def use(middleware, *args)
      middleware_string = middleware.to_s
      if middleware_string.include?('Miron::Mironfile::')
        middleware_constant = middleware_string.gsub!('Miron::Mironfile::', '').constantize
      else
        middleware_constant = middleware_string.constantize
      end

      if args.empty?
        @middleware << middleware_constant
      else
        @middleware << middleware_constant.new(args)
      end
    end
  end
end

def run(_app, *_args)
end

def use(_middleware, *_args)
end
