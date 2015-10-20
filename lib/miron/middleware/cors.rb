module Miron
  module Middleware
    class Cors
      def initialize(&block)
        instance_eval(&block) if block_given?
      end

      def call(request, response)
        origin_header = request.hash['HTTP_ORIGIN'] || request.hash['HTTP_X_ORIGIN']

        if origin_header
          log = [ 'Incoming Headers:',
                  "  Origin: #{origin_header}",
                  "  Access-Control-Request-Method: #{request.hash['HTTP_ACCESS_CONTROL_REQUEST_METHOD']}",
                  "  Access-Control-Request-Headers: #{request.hash['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}"
                ].join("\n")
          puts log
        else
          #
        end
      end

      # Public API
      #-----------------------------------------------------------------------------#

      def allow(&block)
        Resource.new.instance_eval(&block)
      end

      class Resource
        def initialize
          @origins = []
          @resources = []
        end

        def origins(*args, &block)
          #
        end

        def resources(path, options = {})
          #
        end
      end
    end
  end
end
