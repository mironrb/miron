# Here's an example of just a standard Miron app.
# This code should go into a `Mironfile.rb`.

class AppMiddleware
  def call(request, response)
    # When AppMiddleware is called, hi will be puts'ed
    puts 'hi'
  end
end

class App
  def call(request, response)
    # Set your Integer HTTP status here.
    response.http_status = 200
    # Set your Hash of HTTP headers here.
    response.headers = {}
    # Set your String of HTTP body here.
    response.body = 'hi'
    # Set your Hash of HTTP cookies here.
    # Don't worry about `Set-Cookie`, that's handled down the line for you. :)
    response.cookies = { 'HELLO' => 'HELLO' }
    # Finally, return the response upstream for delivery.
    return response
  end
end

use Middleware
run App
