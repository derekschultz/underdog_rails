require 'json'
require 'open-uri'

class Player < ApplicationRecord
  has_many :player_stats
  has_many :games, through: :player_stats

  # validates :name_brief, :first_name, :last_name, :position, :sport, presence: true

  def brief_name(sport)
    case sport
    when 'baseball'
      "#{first_name[0]}. #{last_name[0]}."
    when 'basketball'
      "#{first_name} #{last_name[0]}."
    when 'football'
      "#{first_name[0]}. #{last_name}"
    end
  end

  def position_avg_age_diff(position)
    position_players = Player.where(position: position).pluck(:age).compact
    position_count = position_players.size

    return 0 if position_count.zero? || position_players.empty?

    average_age = position_players.sum / position_players.count.to_f
    age - average_age
  end
end
