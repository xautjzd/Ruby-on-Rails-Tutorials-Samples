class UsersController < ApplicationController
	#default will filter all actions
	before_action :signed_in_user, only: [:index, :edit, :update]
	before_action :correct_user, only:[:edit, :update]
	before_action :admin_user, only: :destroy

	def index
		# @users = User.all
		@users = User.paginate(page: params[:page])
	end

  def new
		@user = User.new
  end

	def create
		#@user = User.new(params[:user])
		@user = User.new(user_params) #防止用户在params填充其他数据
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to xautjzd's Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

  def show
	  @user = User.find(params[:id])
  end

	def edit
		# @user = User.find(params[:id])
	end
	
	def update
		# @user = User.find(params[:id])
		if @user.update_attributes(user_params)
			flash[:success] = "Profile udpated"
			sign_in @user
			redirect_to @user
		else
			render "edit"
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to users_url
	end

	private
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end

		#Before filters
		def signed_in_user
			unless signed_in?
				store_location
				#notice：xxx equal to flash[:notice]=xxx
				redirect_to signin_url, notice: "Please sign in." unless signed_in?
			end
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end

		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
end
