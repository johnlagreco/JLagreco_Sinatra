require "sinatra"
require "sinatra/activerecord"

set :database, "sqlite3:myblogdb.sqlite3"

enable :sessions

require "./models"

get '/' do
	@user = current_user
	if @user
	@users = User.all
	erb :index
	else
		redirect 'sign-in'
	end 
end

get '/sign-in' do
	erb :signin
end

post 'sign-in' do
	@user = User.where(first_name: params[:first_name]).first

	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
	 	redirect '/'
	 else
	 	redirect 'sign-in'
	 end 
end

def current_user
	if session[:user_id]
	@current_user = User.find(session[:user_id])
	end
end