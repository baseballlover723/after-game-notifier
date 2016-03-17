require 'queue_proxy'
require 'thread'
class MainController < ApplicationController
  @@keys = QueueProxy.new
  ENV["RIOT_API_KEYS"].split(" ").each do |key|
    @@keys << key
  end
  @@key_index = -1
  @@key_sleep = Integer(ENV["KEY_SLEEP"]).seconds || 4.seconds
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


  def foo
    n = params[:n].to_i
    sleep n
    render :text => "I should have taken #{n} seconds!"
  end

  def index
    gon.basePath = home_path
  end

  def individual
    puts Thread.list.count
    respond_to do |format|
      format.html do
        gon.currentPath = request.url
        json = handle_json(params[:region], params[:username], true)
        @invalid_summoner = json == @@json_invalid_summoner
        @out_game = json == @@json_out_game
        @in_game = json == @@json_in_game
        gon.startRequestLoop = @in_game

        @region = params[:region]
        @username = Username.where(region: @region, stripped_username: params[:username].gsub(/\s+/, "").downcase)[0].try(:username) || params[:username]
      end
      format.json do
        render json: handle_json(params[:region], params[:username], false)
      end
    end
  end

  def handle_json(region, username, fast)
    # return render json: @@json_out_game
    user_id = get_user_id region, username
    return @@json_invalid_summoner unless user_id
    key = next_key fast
    game_uri = URI::HTTPS.build(host: region + @@request_base,
                                path: @@game_path + translate_region(region) + "/" + user_id,
                                query: {api_key: key}.to_query)
    json = HTTParty.get(game_uri, verify: false)
    json["gameId"] ? @@json_in_game : @@json_out_game
  end

  def get_user_id(region, username)
    db_username = Username.where(region: region, stripped_username: username.gsub(/\s+/, "").downcase)[0]
    return db_username.user_id if db_username
    puts "asking riot for region: #{region}, username: #{username}'s id"
    key = next_key true
    id_uri = URI::HTTPS.build(host: region + @@request_base,
                              path: @@id_path1 + region + @@id_path2 + username.gsub(/\s+/, ""),
                              query: {api_key: key}.to_query)
    json = HTTParty.get(id_uri, verify: false)
    if json[username.gsub(/\s+/, "").downcase]
      Username.create(region: region, stripped_username: username.gsub(/\s+/, "").downcase, username: json[username.gsub(/\s+/, "").downcase]["name"], user_id: json[username.gsub(/\s+/, "").downcase]["id"])
      json[username.gsub(/\s+/, "").downcase]["id"].to_s
    end
  end

  def next_key(fast)
    key = fast ? @@keys.fast_pop : @@keys.slow_pop
    puts "popped #{key} off of the queue"
    Thread.new do
      sleep @@key_sleep
      puts "readded key: #{key} to queue"
      @@keys << key
    end
    key
    # @@key_index += 1
    # @@key_index = 0 if @@key_index >= @@keys.length
    # sleep @@key_sleep - (Time.current - @@key_times[@@key_index]) if (Time.current - @@key_times[@@key_index]) < @@key_sleep
    # puts "using key: #{@@keys[@@key_index]}"
    # #rate limit
    # @@key_times[@@key_index] = Time.current
    # @@keys[@@key_index]
  end

  def translate_region(region)
    @@region_translator[region.to_sym]
  end

end
