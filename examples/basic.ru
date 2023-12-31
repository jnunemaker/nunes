# Usage:
#   bundle exec rackup examples/basic.ru -p 9999
#
#   http://localhost:9999/
#
require "bundler/setup"
require "rack/reloader"
require "nunes"

use Rack::Reloader
use Nunes::Middleware
run lambda { |env|
  request = Rack::Request.new(env)

  p request.path
  case request.path
  when "/"
    sleep rand(0.1..0.5)
    html = <<-HTML
      <!doctype html>
      <html lang="en">
        <head>
          <title>Nunes</title>
          <link href="/application.css" rel="stylesheet">
        </head>
        <body>
          <h1>Home</h1>
          <p><a href="/nunes">Nunes</a></p>
          <script src="/application.js"></script>
        </body>
      </html>
    HTML
    [200, {"content-type" => "text/html"}, [html]]
  when "/application.css"
    sleep rand(0.1..0.5)
    css = "h1 { color: red; }"
    [200, {"content-type" => "text/css"}, [css]]
  when "/application.js"
    sleep rand(0.1..0.5)
    js = "console.log('working')"
    [200, {"content-type" => "application/javascript"}, [js]]
  end
}
