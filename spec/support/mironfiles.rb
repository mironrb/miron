def create_mironfile(dir)
  FileUtils.rm(dir + 'Mironfile.rb') if File.exist?(dir + 'Mironfile.rb')
  (dir + 'Mironfile.rb').open('w') do |f|
    f << "class Hi
  def call(request, response)
    response.http_status = 200
    response.headers = { 'HELLO' => 'HELLO'}
    response.body = 'hi'
    response.cookies = { 'HELLO' => 'HELLO' }
    return response
  end
end

class HiTwo
  def call(request, response)
  end
end

use HiTwo
run Hi"
  end
end

def create_mironfile_args(dir)
  FileUtils.rm(dir + 'Mironfile1.rb') if File.exist?(dir + 'Mironfile1.rb')
  (dir + 'Mironfile1.rb').open('w') do |f|
    f << "class HiThree
  def initialize(hi)
    @hi = hi
  end
  def call(request, response)
    response.http_status = 200
    response.headers = { 'HELLO' => 'HELLO'}
    response.body = 'hi'
    response.cookies = { 'HELLO' => 'HELLO' }
    return response
  end
end

class HiFour
  def initialize(hi)
    @hi = hi
  end
  def call(request, response)
  end
end

use HiFour, 'hi'
run HiThree, 'hi'"
  end
end

def create_mironfile_basic_auth(dir)
  FileUtils.rm(dir + 'Mironfile2.rb') if File.exist?(dir + 'Mironfile2.rb')
  (dir + 'Mironfile2.rb').open('w') do |f|
    f << "class Hi
  def call(request, response)
    response.http_status = 200
    response.headers = { 'HELLO' => 'HELLO'}
    response.body = 'hi'
    response.cookies = { 'HELLO' => 'HELLO' }
    return response
  end
end

use Miron::Middleware::BasicAuth, 'hello', 'hello'
run Hi"
  end
end

def create_mironfile_ssl(dir)
  FileUtils.rm(dir + 'Mironfile4.rb') if File.exist?(dir + 'Mironfile4.rb')
  (dir + 'Mironfile4.rb').open('w') do |f|
    f << "class Hi
  def call(request, response)
    response.http_status = 200
    response.headers = { 'HELLO' => 'HELLO'}
    response.body = 'hi'
    response.cookies = { 'HELLO' => 'HELLO' }
    return response
  end
end

use Miron::Middleware::SSL
run Hi"
  end
end

def create_mironfile_static(dir)
  FileUtils.rm(dir + 'Mironfile3.rb') if File.exist?(dir + 'Mironfile3.rb')
  (dir + 'Mironfile3.rb').open('w') do |f|
    f << "run Miron::Middleware::Static, 'spec/support/hello'"
  end
end
