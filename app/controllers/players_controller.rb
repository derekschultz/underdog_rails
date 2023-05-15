class PlayersController < ApplicationController
  def show
    @player = Player.find(params[:id])
    render json: player_json(@player)
  end

  def search
    sport = params[:sport]
    position = params[:position]
    initial = params[:initial]
    age = params[:age].to_i if params[:age].present?
    min_age = params[:min_age].to_i if params[:min_age].present?
    max_age = params[:max_age].to_i if params[:max_age].present?

    @players = Player.all
    @players = @players.where(position: position) if position.present?
    @players = @players.where('last_name LIKE ?', "#{initial}%") if initial.present?
    @players = @players.where(age: age) if age.present?
    @players = @players.where(age: min_age..max_age) if min_age.present? && max_age.present?
    @players = @players.where(sport: sport) if sport.present?

    render json: @players.select(:id, :first_name, :last_name, :position, :age)
                        .map { |player| player_json(player) }
  end

  private

  def average_position_age_diff(player)
    return nil if player.age.nil?

    position_players = Player.where(position: player.position).pluck(:age).compact
    position_count = position_players.count
    return nil if position_count.zero?

    position_age_sum = position_players.sum
    average_age = position_age_sum / position_count.to_f
    player.age - average_age
  end

  def player_json(player)
    {
      id: player.id,
      name_brief: name_brief(player),
      first_name: player.first_name,
      last_name: player.last_name,
      position: player.position,
      age: player.age,
      average_position_age_diff: average_position_age_diff(player)
    }.compact.to_h
  end
end
