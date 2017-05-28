class MicropostsController < ApplicationController
  
  before_action :logged_in_user, only: [:create, :destroy]

  def create
  end

  def destroy
  end
  
  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end
    
end
