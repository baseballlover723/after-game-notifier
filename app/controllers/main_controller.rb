class MainController < ApplicationController
  @@keys = ENV["RIOT_API_KEYS"].split(" ")
  @@key_index = -1
  @@key_sleep = 2.seconds
  @@key_times = [].fill(Time.current - @@key_sleep, 0...@@keys.length)

  @@request_base = ".api.pvp.net"
  @@game_path = "/observer-mode/rest/consumer/getSpectatorGameInfo/"
  @@id_path1 = "/api/lol/"
  @@id_path2 = "/v1.4/summoner/by-name/"
  @@region_translator = {br: "BR1", eune: "EUN1", euw: "EUW1", kr: "KR", lan: "LA1", las: "LA2",
                         na: "NA1", oce: "OC1", ru: "RU", tr: "TR1"}

  @@json_invalid_summoner = {valid: false, in_game: true}
  @@json_in_game = {valid: true, in_game: true}
  @@json_out_game = {valid: true, in_game: false}


  def index
    gon.baseRoute = home_path
  end

  def individual
    respond_to do |format|
      format.html do
        gon.username = params[:username]
        gon.region = params[:region]
      end
      format.json do
        handle_json(params[:region], params[:username])
      end
    end
  end

  def handle_json(region, username)
    user_id = get_user_id region, username
    return render json: @@json_invalid_summoner unless user_id
    key = next_key
    game_uri = URI::HTTPS.build(host: region + @@request_base,
                                path: @@game_path + translate_region(region) + "/" + user_id,
                                query: {api_key: key}.to_query)
    json = HTTParty.get(game_uri, verify: false)
    render json: json["gameId"] ? @@json_in_game : @@json_out_game
  end

  def get_user_id(region, username)
    db_username = Username.where(region: region, username: username)[0]
    return db_username.id.to_s if db_username
    puts "asking riot for region: #{region}, username: #{username}'s id"
    key = next_key
    id_uri = URI::HTTPS.build(host: region + @@request_base,
                              path: @@id_path1 + region + @@id_path2 + username,
                              query: {api_key: key}.to_query)
    json = HTTParty.get(id_uri, verify: false)
    if json[username.downcase]
      Username.create(region: region, username: username, id: json[username.downcase]["id"].to_s)
      json[username.downcase]["id"].to_s
    end
  end

  def next_key
    @@key_index += 1
    @@key_index = 0 if @@key_index >= @@keys.length
    while (Time.current - @@key_times[@@key_index]) < @@key_sleep
    end
    #rate limit
    @@key_times[@@key_index] = Time.current
    @@keys[@@key_index]
  end

  def translate_region(region)
    @@region_translator[region.to_sym]
  end

end
