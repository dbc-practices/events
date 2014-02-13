get '/' do
  # Look in app/views/index.erb
  @user = session[:user_id]
  erb :index
end

get '/login' do
  erb :login
end

get '/home' do
  @user = User.find(session[:user_id])
  erb :home
end

post '/sign-up' do
  @user = User.create(first_name: params[:firstname],
                      last_name: params[:lastname],
                      email: params[:email],
                      birthdate: params[:bday],
                      password_digest: params[:password])
  puts params
  if @user.invalid?
    redirect '/error'
  else
    session[:user_id] = @user.id
    redirect '/home'
  end
end

post '/sign-in' do
  @user = User.find_by(email: params[:email], password_digest: params[:password])
  if @user.nil?
    redirect '/error'
  else
    session[:user_id] = @user.id
    redirect '/home'
  end
end

get '/events/new' do
  erb :event_new
end

post '/events/create' do
  user = User.find(session[:user_id])
  puts params
  puts params[:start]
  puts params[:end]
  @event = user.created_events.create(name: params[:name],
                              location: params[:location],
                              starts_at: params[:start],
                              ends_at: params[:end])
  puts @event.starts_at
  puts @event.ends_at
  if @event.invalid?
    redirect '/error'
  else
    redirect '/home'
  end
end

post '/events/create/ajax' do

end

get '/events/list_created' do
  @events = User.find(session[:user_id]).created_events
  if @events.nil?
    redirect '/error'
  else
    erb :events_created
  end
end

get '/events/list_attended' do
  @events = User.find(session[:user_id]).attended_events
  if @events.nil?
    redirect '/error'
  else
    erb :events_attended
  end
end

get '/events/:id' do
  @event = Event.find(params[:id])
  @creator = @event.creator.first_name + ' ' + @event.creator.last_name
  @guests = @event.guests
  erb :event
end

get '/events/edit/:id' do
  @event = Event.find(params[:id])
  erb :edit_event
end

post '/events/edit/:id' do
  event = Event.find(params[:id])
  status = event.update(name: params[:name],
                        location: params[:location]) #REVISIT DATE CONVERSION!
  if status == true
    redirect to "/events/#{event.id}"
  else
    erb :error
  end
end

get '/events/delete/:id' do
  @event = Event.find(params[:id])
  erb :delete_event
end

post '/events/delete/:id' do
  @event = Event.find(params[:id])
  if params[:response].nil?
    redirect to ("/event/#{params[:id]}")
  else
    Event.find(params[:id]).destroy
    redirect to ('/home')
  end
end

get '/error' do
  erb :error
end

get '/logout' do
  session.clear
  redirect '/'
end





















