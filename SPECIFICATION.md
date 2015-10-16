# The Miron Specification

Welcome! This is the guide to the Miron Specification, a specification
that web servers and applications must follow if they want to
communicate over the web via Miron's APIs. See below for the table of
contents to skip directly to the part that's most important to you.

**Thanks to Rack for serving as an inspiration while creating Miron.**

- [For Web Servers]()
- [For Web Applications]()

# For Web Servers

This section of the Miron Specification goes through all of the
information that a web server must provide and use when communicating
using Miron. If you have any questions, feel free to open up an issue.
:)

### The server must provide all of the following data via a hash:

Please be aware that unless otherwise stated, all of the following hash
keys and values are **required**. If no data is provided via the HTTP
request, then the value for the key may be an empty string.

- `HTTP_METHOD`: The HTTP request method, such as "GET" or "POST".
- `PATH`: The request URL's "path", can be "/" or "/apples/honey".
- `HTTP_VERSION`: The version of HTTP that the request was made with. An
  example of this would be "HTTP/1.1".
- `QUERY_STRING`: The portion of the request URL that follows a "?".
- `HTTP_` Variables: Variables corresponding to the client supplied HTTP
  request headers. For example, if the HTTP header "Sec-Websocket-Key"
is provided in the client request, the hash should contain a
`HTTP_SEC_WEBSOCKET_KEY` key, with a value that matches that of the HTTP
header.

All of the above hash keys and values were set via data from the client request.
The following hash keys and values need to be set by the web server
directly.

- `miron.version`: The latest version of the Miron gem you are
  running. This serves as a reference as to what version of the
specification you are running, but also what features from Miron can be
accessed through your web server.
- `miron.socket`: This should be a `TCPSocket` or similar that can be used by the
  web application to process websocket requests or similar. A web server
should take care to make sure that `miron.socket` will be activated, and
thus the request socket-ified (isn't it fun to make up words?), when
`.call` is done on the `miron.socket`.

# For Web Applications

It's awesome you want to run your web application on Miron. Be sure to
follow the guidelines listed below, and you're off to the races! :)

### How To Process Requests

The primary job of any web application is to process HTTP requests. In
Miron-land, this is accomplished by having a Ruby class define a `call`
method that takes in instances of `Miron::Request` and
`Miron::Response`, and then returns that same `Miron::Response` instance
with a status code, headers, and all that good stuff. The following
point is very important: If your takes in variables via the Mironfile,
then make sure you have an initialize method for your app or middleware
that receives these variables. Also, make sure the `call` method is an
instance method, so not `self.call`.

Here's an example of an app that does not take in parameters. The below
code would go inside of a Mironfile.rb:

```ruby
class Hi
  def self.call(request, response)
    response.http_status = 200
    response.headers = { 'HI' => 'HI' }
    response.body = 'hi'
    response.cookies = { 'HI' => 'HI' }
    return response
  end
end

run Hi
```

Here's an example of an app that does take in parameters. The below
code would go inside of a Mironfile.rb:

```ruby
class Hi
  def initialize(sup)
    puts sup
  end

  def call(request, response)
    response.http_status = 200
    response.headers = { 'HI' => 'HI' }
    response.body = 'hi'
    response.cookies = { 'HI' => 'HI' }
    return response
  end
end

run Hi, 'hello'
```

If you have any questions, feel free to open up an issue. :)

For more information about apps and middlewares, check out
`Miron:::Mironfile`.

# That's All, Folks!

Thanks for reading through the Miron Specification. If you have any
questions or concerns, feel free to open up a Github issue on the
project's repository.
