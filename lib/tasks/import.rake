require 'net/http'
require 'json'

namespace :import do
  desc "Import and persist players from CBS API"
  task players: :environment do
    sports = ['baseball', 'football', 'basketball']

    sports.each do |sport|
      url = "http://api.cbssports.com/fantasy/players/list?version=3.0&SPORT=#{sport}&response_format=JSON"
      uri = URI.parse(url)
      puts "Fetching players from #{uri}"

      begin
        response = Net::HTTP.get_response(uri)

        while response.is_a?(Net::HTTPRedirection)
          new_url = response['location']
          response = Net::HTTP.get_response(URI.parse(new_url))
        end

        data = JSON.parse!(response.body)
        players_data = data.dig('body', 'players') || []

        players_data.each do |player_data|
          player = Player.find_or_initialize_by(id: player_data['id']) do |p|
            p.name_brief = p.brief_name(sport)
            p.first_name = player_data['firstname']
            p.last_name = player_data['lastname']
            p.position = player_data['position']
            p.age = player_data['age']
            p.average_position_age_diff = p.position_avg_age_diff(player_data['position'])
            p.sport = sport
            p.save
          end

          if player.valid?
            player.update(
              name_brief: player.brief_name(sport),
              first_name: player_data['firstname'],
              last_name: player_data['lastname'],
              position: player_data['position'],
              age: player_data['age'],
              average_position_age_diff: player.position_avg_age_diff(player_data['position']),
              sport: sport
            )
          else
            Rails.logger.error "Failed to save player #{player_data['id']}: #{player.errors.full_messages}"
            next
          end
        end
      rescue JSON::ParserError => e
        Rails.logger.error "Failed to parse JSON response for #{sport}: #{e}"
      rescue StandardError => e
        Rails.logger.error "Error fetching players for #{sport}: #{e}"
      end
    end
  end
end
