# Here's an example of just a regular old Miron app.
# This code should go into a `Mironfile.rb`.
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

run App
