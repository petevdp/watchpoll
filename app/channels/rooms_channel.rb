require 'timeout'

class RoomsChannel < ApplicationCable::Channel
  def subscribed
    puts 'Subscribed!'
    @num_bcs = 0;
    @room = Room.find(params[:room_id])
    puts 'room' + @room.id.to_s
    stream_for @room
  end

  def self.broadcast_state(room)
    puts 'broadcasting'
    puts "id: #{room.id}"
    RoomsChannel.broadcast_to(
      room,
      room.state
    )
  end

  def receive(data)
    @user_session = UserSession.find(data['session_id'])
    RoomsChannel.broadcast_state(@room)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts 'unsubscribed!'
    @user_session.update(end: Time.now)
    @user_session.reload
    RoomsChannel.broadcast_state(@room)
  end
end
