class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by_email params[:email]

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id # encrypted by default using a secret_key in config/secrets.yml
      redirect_to root_path, notice: "Logged In!"
    else
        flash[:alert] = "Wrong credentials!"
        render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged Out!"
  end
end
