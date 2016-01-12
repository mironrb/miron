require 'socket'

class HTTP2Listener
  def initialize
    uri = URI.parse(ARGV[0] || 'http://localhost:9295/')
    tcp = TCPSocket.new(uri.host, uri.port)
    sock = nil

    if uri.scheme == 'https'
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE

      ctx.npn_protocols = [DRAFT]
      ctx.npn_select_cb = lambda do |protocols|
        puts "NPN protocols supported by server: #{protocols}"
        DRAFT if protocols.include? DRAFT
      end

      sock = OpenSSL::SSL::SSLSocket.new(tcp, ctx)
      sock.sync_close = true
      sock.hostname = uri.hostname
      sock.connect

      if sock.npn_protocol != DRAFT
        puts "Failed to negotiate #{DRAFT} via NPN"
        exit
      end
    else
      sock = tcp
    end

    conn = HTTP2::Client.new
    stream = conn.new_stream

    stream.on(:close) do
      sock.close
    end

    head = {
      ':scheme' => uri.scheme,
      ':method' => ('GET'),
      ':authority' => [uri.host, uri.port].join(':'),
      ':path' => uri.path,
      'accept' => '*/*',
    }

    stream.headers(head, end_stream: true)

    while !sock.closed? && !sock.eof?
      data = sock.read_nonblock(1024)

      begin
        conn << data
        puts "conn: #{conn}"
        require 'pry'; binding.pry
      rescue => e
        puts "Exception: #{e}, #{e.message} - closing socket."
        sock.close
      end
    end
  end
end
