module Miron
  module Handler
    # @param  [String] handler_name
    #         inheritor of {Miron::Handler} to try and use to run a Miron-backed server
    #
    # @return [Miron::Handler]
    #         returns constant of handler_name, if it can be found
    #
    # @return [Miron::Handler]
    #         returns the newly created {Miron::Response}
    #         returns constant of {Miron::Handle::WEBrick}, if handler_name cannot be found
    #
    def self.get(handler_name)
      if !handler_name.nil? && Miron::Handler.const_defined?(:"#{handler_name.capitalize}")
        Miron::Handler.const_get(:"#{handler_name.capitalize}")
      else
        Miron::Handler::WEBrick
      end
    end
  end
end
