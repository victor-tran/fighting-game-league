class MatchesController < ApplicationController
	def edit
		@match = Match.find(params[:id])
	end

	def update
		@match = Match.find(params[:id])
		if @match.update_attributes(match_params)
			flash[:success] = "Match score successfully submitted."
			redirect_to root_url
		else
			render 'edit'
		end
	end

  private
    def match_params
      params.require(:match).permit(:p1_score, :p2_score)
    end	
end
