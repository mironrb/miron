require 'socket'

class HTTP2Listener
  DRAFT = 'h2'

  attr_reader :data

  class Logger
    def initialize(id)
      @id = id
    end

    def info(msg)
      puts "[Stream #{@id}]: #{msg}"
    end
  end

  def initialize
    uri = URI.parse('https://localhost:9295/')
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
    logger = Logger.new(stream.id)

    stream.on(:headers) do |h|
      log.info "response headers: #{h}"
      sock.close
    end

    conn.on(:frame) do |bytes|
      puts "Sending bytes: #{bytes.unpack("H*").first}"
      sock.print bytes
      sock.flush
    end

    stream.on(:data) do |d|
      log.info "response data chunk: <<#{d}>>"
      sock.close
    end

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
        logger.info "conn: #{conn}"
      rescue => e
        puts "Exception: #{e}, #{e.message} - closing socket."
        sock.close
      end
    end
  end
end
