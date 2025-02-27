Yt.configuration.api_key = 'AIzaSyAQoqZ6oaSG5DP-zhSevbZRyorCIYiUgLs'
Yt.configure do |config|
  config.log_level = :debug
end

class Playlist < ApplicationRecord
  has_many :videos
  has_many :rooms

  def self.create(args)
    playlist_uid = args[:playlist_uid]
    yt_playlist = Yt::Playlist.new(id: playlist_uid)
    playlist = Playlist.new(
      title: yt_playlist.title,
      playlist_uid: playlist_uid
    )

    yt_playlist.playlist_items.each do |item|
      Video.create(
        video_uid: item.video_id,
        playlist: playlist,
        title: item.title
      )
    end
    playlist.save
    playlist
  end

  def get_random_video
    self.videos.order("RANDOM()").limit(1).first
  end

end
