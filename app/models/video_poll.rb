class VideoPoll < ApplicationRecord
  belongs_to :room
  has_many :preference_orders
  has_many :user_sessions
  has_many :candidate_videos

  def played_video
    Video.find @played_video_id
  end

  def played_video= video
    @played_video_id = video.id
  end


  def get_unused_random_video
    video = room.playlist.get_random_video
    unused_count =  candidate_videos.inject(0) do |unused_count, candidate_video|
      if candidate_video.video.id == video.id
        unused_count
      else
        unused_count + 1
      end
    end

    if unused_count == 0
      return nil
    end

    unless already_used
      return video
    end
    get_unused_random_video

  end

  def select_winner
    @played_video_id = standings
      .sort_by { |candidate| -candidate[:points] }
      .first[:video_id]
    played_video
  end

  def standings
    active_user_sessions = room.user_sessions.where(end: nil)
    active_session_preferences = active_user_sessions
      .select do |user_session|
        user_session.preference_orders.length > 0
      end
      .map do |user_session|
        user_session.preference_orders.last.preferences
      end
      .flatten
    puts "poll_id: #{id}"
    candidate_videos.map do |c_video|
      video_preferences = c_video.preferences
      points = video_preferences.sum do |preference|
        orda_count_formula(candidate_videos.length, preference.position)
      end
      video = c_video.video
      {video_id: video.id, candidate_video_id: c_video.id, video_uid: video.video_uid, points: points, title: video.title}
    end
  end

  private
  def orda_count_formula(length, position)
    length - position
  end
end