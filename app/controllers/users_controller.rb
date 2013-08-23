class UsersController < ApplicationController
  def new
		@user = User.new
  end

	def create
		#@user = User.new(params[:user])
		@user = User.new(user_params) #防止用户在params填充其他数据
		if @user.save
			flash[:success] = "Welcome to xautjzd's Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

  def show
	  @user = User.find(params[:id])
  end

	private
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end
end
