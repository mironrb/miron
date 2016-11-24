# Here's an example of just a regular old Miron app.
# This code should go into a `Mironfile.rb`.

class App
  def call(request, response)
    if request.multipart?
      data = request.fetch_multipart_data
      puts "The bytesize of the multipart data is equal to: #{data[:file_contents].size}"
      puts "The filename of the multipart data is equal to: #{data[:file_name]}"
      puts "The file type of the multipart data is equal to: #{data[:file_type]}"
    end

    response.http_status = 200
    response.headers = {}
    response.body = 'hi'
    return response
  end
end

run App
