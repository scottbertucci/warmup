class UsersController < ApplicationController

  def add
    username = params[:name]
	password = params[:password]
    if username.length == 0
	  render :json => { errCode: -3} #ERR_BAD_USERNAME
    elsif username.length >= 128
	  render :json => { errCode: -3} #ERR_BAD_USERNAME
	elsif password.length >= 128
	  render :json => { errCode: -4} #ERR_BAD_PASSWORD
	elsif User.find_by_name(username) != nil
	  render :json => { errCode: -2} #ERR_USER_EXISTS
	else
	  @user = User.new(name: username.downcase, password: password, count: 1)
	  @user.save
	  render :json => { errCode: 1, count: 1} #SUCCESS
	end
  end

  def login
    username = params[:name]
	password = params[:password]
    if username.length == 0
	  render :json => { errCode: -3} #ERR_BAD_USERNAME
    elsif username.length >= 128
	  render :json => { errCode: -3} #ERR_BAD_USERNAME
	elsif User.find_by_name(username.downcase) == nil
	  render :json => { errCode: -1} #ERR_BAD_CREDENTIALS
	elsif password != User.find_by_name(username.downcase).password
	  render :json => { errCode: -1} #ERR_BAD_CREDENTIALS
	else
	  @user = User.find_by_name(username.downcase)
	  @user.count = @user.count + 1
	  @user.save
	  render :json => { errCode: 1, count: @user.count} #SUCCESS
	end
  end
  
  def reset
    users.destroy_all()
    render :json => { errCode: 1} #SUCCESS
  end
  
  def tests
  end
  
  
  def client
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @error = nil
	
	if params[:login]
	  if :username.length == 0
	    @error = -3 #ERR_BAD_USERNAME
      elsif :username.length >= 128
	    @error = -3 #ERR_BAD_USERNAME
	  elsif User.find_by_name(:username.downcase) == nil
	    @error = -1 #ERR_BAD_CREDENTIALS
	  elsif :password != User.find_by_name(:username.downcase).password
	    @error = -1 #ERR_BAD_CREDENTIALS
	  else
	    @user = User.find_by_name(:username.downcase)
	    @user.count = @user.count + 1
	    @user.save
	    @error = 1 #SUCCESS
	  end
	else
	  if :username.length == 0
	    @error = -3 #ERR_BAD_USERNAME
      elsif :username.length >= 128
	    @error = -3 #ERR_BAD_USERNAME
	  elsif :password.length >= 128
	    @error = -4 #ERR_BAD_PASSWORD
	  elsif User.find_by_name(:username)
	    @error = -2 #ERR_USER_EXISTS
	  else
	    @user = User.new(name: :username.downcase, password: :password, count: 1)
	    @user.save
	    @error = 1 #SUCCESS
	  end
	end
	
	if @error == 1
	  redirect_to @user
	else
	  @user = User.new
	  if @error == -1
	    @message = "Username or Password incorrect"
	  elsif @error == -2
	    @message = "Username already taken"
	  elsif @error == -3
	    @message = "Invalid Username"
	  elsif @error == -4
	    @message = "Invalid Password"
	  end
	  render 'client'
	end
	
  end
   
end
