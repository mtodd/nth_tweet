helpers do
  def get_tweets(username, results = [])
    # MAX_RESULTS / REQUESTS_PER_PAGE
    1.upto(3) do |page|
      results.concat(Twitter.timeline(username, :page => page, :rpp => REQUESTS_PER_PAGE))
    end
    results
  end
  
  def get_nth_tweets(username, n, results = [])
    get_tweets(username).each_with_index do |tweet, index|
      if index % n == 0 # Nth modulos to 0
        results << [index, tweet]
      end
    end
    results
  end
end

get '/tweets' do
  @tweets = get_nth_tweets(params[:username], (params[:n] || DEFAULT_N).to_i)
  erb :tweets
end

get '/tweets.json' do
  @tweets = get_nth_tweets(params[:username], (params[:n] || DEFAULT_N).to_i)
  Hash[*@tweets.flatten].to_json
end
