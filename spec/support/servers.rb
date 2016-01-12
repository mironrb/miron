def sample_basic_auth_app(auth:)
  create_mironfile_basic_auth(SpecHelper.temporary_directory)
  @mironfile = Miron::Mironfile.from_file(SpecHelper.temporary_directory + 'Mironfile2.rb')
  if auth == true
    port = '9290'
  else
    port = '9291'
  end
  webrick_server = Miron::Server.new(@mironfile, { 'handler' => 'webrick', 'port' => port })
  @thread = Thread.new { webrick_server.start }
  trap(:INT) { @thread.stop }
end

#def sample_http2_app
  #create_mironfile(SpecHelper.temporary_directory)
  #@mironfile = Miron::Mironfile.from_dir(SpecHelper.temporary_directory)
  #http2_server = Miron::Server.new(@mironfile, { 'handler' => 'http2', 'port' => '9290' })
  #@thread = Thread.new { http2_server.start }
  #trap(:INT) { @thread.stop }
#end

def sample_puma_app
  create_mironfile(SpecHelper.temporary_directory)
  @mironfile = Miron::Mironfile.from_dir(SpecHelper.temporary_directory)
  puma_server = Miron::Server.new(@mironfile, { 'handler' => 'puma', 'port' => '9290' })
  @thread = Thread.new { puma_server.start }
  trap(:INT) { @thread.stop }
end

def sample_static_app
  create_mironfile_static(SpecHelper.temporary_directory)
  @mironfile = Miron::Mironfile.from_file(SpecHelper.temporary_directory + 'Mironfile3.rb')
  webrick_server = Miron::Server.new(@mironfile, { 'handler' => 'webrick', 'port' => '9294' })
  @thread = Thread.new { webrick_server.start }
  trap(:INT) { @thread.stop }
end

def sample_thin_app
  create_mironfile(SpecHelper.temporary_directory)
  @mironfile = Miron::Mironfile.from_dir(SpecHelper.temporary_directory)
  thin_server = Miron::Server.new(@mironfile, { 'handler' => 'thin', 'port' => '9290' })
  @thread = Thread.new { thin_server.start }
  trap(:INT) { @thread.stop }
end

def sample_unicorn_app
  create_mironfile(SpecHelper.temporary_directory)
  @mironfile = Miron::Mironfile.from_dir(SpecHelper.temporary_directory)
  unicorn_server = Miron::Server.new(@mironfile, { 'handler' => 'unicorn', 'port' => '9290' })
  @thread = Thread.new { unicorn_server.start }
  trap(:INT) { @thread.stop }
end

def sample_webrick_app
  create_mironfile(SpecHelper.temporary_directory)
  @mironfile = Miron::Mironfile.from_dir(SpecHelper.temporary_directory)
  webrick_server = Miron::Server.new(@mironfile, { 'handler' => 'webrick', 'port' => '9290' })
  @thread = Thread.new { webrick_server.start }
  trap(:INT) { @thread.stop }
end
