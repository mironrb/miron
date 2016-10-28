# Here's an example of using websockets in a Miron app.
# This code should go into a `exampleMironApplication.rb`.

class App
  def self.call(request, response)
    # First, check to see if the request is a proper websockets request.
    if request.websocket?
      # A new thread will be opened for each connection.
      Thread.new(request.setup_websocket) do |connection|
        puts "A new client has connected."

        # Below, example lifecycle hooks are defined.
        connection.on :open do |message|
          puts ['open', message]
        end

        connection.on :message do |message|
          connection.send("Received #{message}. Thanks!")
        end

        connection.on :ping do |message|
          puts 'ping'
          connection.pong
        end

        connection.on :close do |message|
          puts 'closing'
        end

        # After defining all lifecycle hooks (open, message, close, etc.), then start your connection!
        connection.start
      end

      # Setting these response values are necessary to tell the server handler that you are performing a streaming response.
      response.http_status = -1
      response.headers = {}
      response.body = nil
      return response
    else
      # Proceed as normal if no websockets. :)
      response.http_status = 200
      response.headers = { 'HELLO' => 'HELLO'}
      response.body = 'hi'
      response.cookies = { 'HELLO' => 'HELLO' }
      return response
    end
  end
end

run App
