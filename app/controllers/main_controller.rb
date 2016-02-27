class MainController < ApplicationController
  def index
  end

  def individual
    respond_to do |format|
      format.html
      format.json do
        handle_json
      end
    end
  end

  def handle_json
    if rand(2) == 1
      json = json_in_game
    else
      json = json_out_game
    end
    render json: json

  end

  def json_in_game
    {in_game: true}
  end
  def json_out_game
    {in_game: false}

  end
end
