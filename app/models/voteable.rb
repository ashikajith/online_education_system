module Voteable
  extend ActiveSupport::Concern

  included do
    field :up_voters,     :type => Array,   :default => []
    field :down_voters,   :type => Array,   :default => []
    field :up_count,      :type => Integer, :default => 0
    field :down_count,    :type => Integer, :default => 0
    field :vote_count,    :type => Integer, :default => 0
  end


  
  def upvote(user)
    vote_handler(current_vote(user), :up, user)
  end

  def upvote_toggle(user)
    vote_handler(current_vote(user), :up, user, 1)
  end

  def downvote(user)
    vote_handler(current_vote(user), :down, user)
  end

  def downvote_toggle(user)
    vote_handler(current_vote(user), :down, user, 1)
  end

  def current_vote(user)
    if self.up_voters.include? user.id.to_s
      :up
    elsif self.down_voters.include? user.id.to_s
      :down
    end
  end

private

  def vote_handler(current, vote, user, toggle = 0)
    if current == vote
      if (current && vote == :up) && toggle == 1
        self.up_voters.delete_if {|x| x == user.id.to_s}
        vote_adjust(-1, 0, -1)
      elsif (current && vote == :down) && toggle == 1
        self.down_voters.delete_if {|x| x == user.id.to_s}
        vote_adjust(0, 1, 1)
      end
    else
      if !current && vote == :up
        self.up_voters << user.id.to_s
        vote_adjust(1, 0, 1)
      elsif !current && vote == :down
        self.down_voters << user.id.to_s
        vote_adjust(0, -1, -1)
      elsif current == :up && vote == :down
        self.up_voters.delete_if {|x| x == user.id.to_s}
        self.down_voters << user.id.to_s
        vote_adjust(-1, -1, -2)        
      elsif current == :down && vote == :up
        self.down_voters.delete_if {|x| x == user.id.to_s}
        self.up_voters << user.id.to_s
        vote_adjust(1, 1, 2)        
      end
    end
  end

  def vote_adjust(up, down, count)
    self.up_count += up
    self.down_count += down
    self.vote_count += count
    self.save
  end
end
