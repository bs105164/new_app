class MicropostsController < ApplicationController
   before_filter :signed_in_user, only: [:create, :destroy]
   before_filter :authorized_user, only: :destroy

   def index
   end
   def create
	@micropost = current_user.microposts.build(params[:micropost])
	if @micropost.save
	   flash[:success] = "Micropost create!"
           redirect_to root_url
	else
           @feed_items = []
	   render 'static_pages/home'
	end
   end

   def destroy
	@micropost.destroy
	redirect_back_or root_path 
   end

  private
    def micropost_params
	params.require(:micropost).permit(:content)
    end


    def authorized_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to(root_path) unless current_user?(@micropost.user)
    end
end
