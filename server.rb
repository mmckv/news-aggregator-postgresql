require "sinatra"
require "pg"
require_relative "./app/models/article"
require "pry"

set :views, File.join(File.dirname(__FILE__), "app", "views")

configure :development do
  set :db_config, { dbname: "news_aggregator_development" }
end
configure :test do
  set :db_config, { dbname: "news_aggregator_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

get '/articles' do
@article_list = Article.all
  erb :index
end

get '/articles/new' do
  erb :show
end
# If I specify a URL that has already been submitted, I receive an error message, and the submission form is re-rendered with the details I have previously submitted.

post '/articles/new' do
@error = nil
article = Article.new(params)
  if article.valid?
    article.save
    redirect '/articles'
  else
    @previous_article = params['title']
    @previous_url = params['url']
    @previous_description = params['description']
    @error = true
    @errors = article.errors
    erb :show
  end
end
