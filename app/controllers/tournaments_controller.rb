class TournamentsController < ApplicationController
  def edit_match_scores
    @tournament = Tournament.find(params[:id])
  end
end
