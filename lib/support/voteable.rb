module Support
  module Voteable
    def self.included(klass)
      klass.class_eval do
        extend ClassMethods
        include InstanceMethods

        field :votes_count, :type => Integer, :default => 0
        field :votes_average, :type => Integer, :default => 0

        field :votes, :type => Hash, :default => {}
      end
    end

    module InstanceMethods
      def vote(value, voter)
        old_vote = self.votes[voter.id]
        if old_vote.nil?
          self.votes[voter.id] = value
          self.save
          add_vote!(value, voter)
          return :created
        else
          if(old_vote != value)
            self.votes[voter.id] = value
            self.save
            self.remove_vote!(old_vote, voter)
            self.add_vote!(value, voter)
            return :updated
          else
            self.votes.delete(voter.id)
            self.save
            remove_vote!(value, voter)
            return :destroyed
          end
        end
      end

      def add_vote!(value, voter)
        if embedded?
          self._parent.increment({self._position+".votes_count" => 1,
                                  self._position+".votes_average" => value.to_i})
        else
          self.increment({:votes_count => 1, :votes_average => value.to_i})
        end
        if value > 0
          self.user.upvote!(self.group)
        else
          self.user.downvote!(self.group)
        end
        self.on_add_vote(value, voter) if self.respond_to?(:on_add_vote)
      end

      def remove_vote!(value, voter)
        if embedded?
          self._parent.increment({self._position+".votes_count" => -1,
                                  self._position+".votes_average" => -value.to_i})
        else
          self.increment({:votes_count => -1, :votes_average => -value})
        end
        if value > 0
          self.user.upvote!(self.group, -1)
        else
          self.user.downvote!(self.group, -1)
        end
        self.on_remove_vote(value, voter) if self.respond_to?(:on_remove_vote)
      end
    end

    module ClassMethods
    end
  end
end
