require 'twitter'
require 'json'

ROOT = File.join(File.dirname(__FILE__), '..')

DEFAULT_N = 100

MAX_RESULTS = 3_200     # Twitter encorced limit
REQUESTS_PER_PAGE = 100 # Twitter encorced limit

Dir.glob(File.join(ROOT, 'app', 'endpoints', '*.rb')).each do |endpoint|
  require endpoint
end

helpers do
  def partial(name, object = nil)
    erb(("_%s" % name).to_sym, :locals => { name.to_sym => object })
  end
end
