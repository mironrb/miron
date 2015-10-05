def sample_puma_app
  create_mironfile(SpecHelper.temporary_directory)
  @mironfile = Miron::Mironfile.from_dir(SpecHelper.temporary_directory)
  puma_server = Miron::Server.new(@mironfile, { 'handler' => 'puma', 'port' => '9290' })
  @thread = Thread.new { puma_server.start }
  trap(:INT) { @thread.stop }
end

def sample_webrick_app
  create_mironfile(SpecHelper.temporary_directory)
  @mironfile = Miron::Mironfile.from_dir(SpecHelper.temporary_directory)
  webrick_server = Miron::Server.new(@mironfile, { 'handler' => 'webrick', 'port' => '9290' })
  @thread = Thread.new { webrick_server.start }
  trap(:INT) { @thread.stop }
end
