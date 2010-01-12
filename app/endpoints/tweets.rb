helpers do
  # WTF? http://gist.github.com/274927
  
  def search(username, page = 1, rpp = REQUESTS_PER_PAGE)
    uri = URI.parse("http://search.twitter.com/search.json?q=from%%3A%s&amp;page=%i&amp;rpp=%i" % [URI.encode(username), page, rpp])
    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      # puts "*"*80
      # puts uri.to_s
      # puts JSON.parse(response.body)['results'].map{|t| t['id'] }.inspect
      JSON.parse(response.body)['results']
    else
      @error = response.message
      []
    end
  end
  
  def fetch_tweets(username, results = [])
    1.upto(MAX_RESULTS / REQUESTS_PER_PAGE) do |page|
      results.concat(search(username, page, REQUESTS_PER_PAGE))
    end
    results
  end
  
  def fetch_n_tweets(username, n, results = [])
    fetch_tweets(username).each_with_index do |tweet, index|
      if index % n == 0 # Nth modulos to 0
        results << [index, tweet]
      end
    end
    results
  end
end

get '/tweets' do
  @tweets = fetch_n_tweets(params[:username], (params[:n] || DEFAULT_N).to_i)
  erb :tweets
end
