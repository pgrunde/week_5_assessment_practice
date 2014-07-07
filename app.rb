require "sinatra"
require "rack-flash"

require "./lib/user_database"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @user_database = UserDatabase.new
  end

  get "/" do
    if session[:user_id]
      @username = @user_database.find(session[:user_id])
      @username = @username[:username]
    end
    erb :root, :locals => { :username => @username }, :layout => :main_layout
  end

  get "/register/" do
    erb :register, :locals => {  }, :layout => :main_layout
  end

  post "/register/" do
    params_sym = params.inject({}) {|memo, (k,v)| memo[k.to_sym] = v; memo }
    @user_database.insert(params_sym)
    flash[:register_notice] = "Thank you for registering."
    redirect "/"
  end

  post "/login/" do
    params_sym = params.inject({}) {|memo, (k,v)| memo[k.to_sym] = v; memo }
    logged_user = @user_database.all.find do |hash|
      params_sym[:username] == hash[:username] && params_sym[:password] == hash[:password]
    end

    if logged_user
      session[:user_id] = logged_user[:id]
    end

    redirect "/"
  end

  get "/logout/" do
    session[:user_id] = nil
    redirect "/"
  end

end
