# - Create a Sinatra app from the ground up that incorporates the following:

#   A User model with at least a fname, lname, email, and password
#   A login form that signs in a user using sessions
#   Have the homepage welcome the user by name if a user is signed in

require "sinatra"
require "sinatra/activerecord"

set :database, "sqlite3:myblogdb.sqlite3"

enable :sessions

require "./models"

get '/' do
	erb :index
end

get '/sign-in' do 
	erb :signin
end

get '/home' do
	@user = current_user
	if @user
		@users = User.all
	erb :home
	else
		redirect '/sign-in'
	end
end

post '/sign-in' do
	@user = User.where(first_name: params[:first_name]).first
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		redirect '/home'
	else
		redirect '/login-failed'
	end
end

get '/login-failed' do
	"Your log-in Failed! Go back, try again"
end

get '/logout' do
	session.clear
	redirect '/sign-in'
end

def current_user
	if session[:user_id]
	@current_user = User.find(session[:user_id])
	end
end

