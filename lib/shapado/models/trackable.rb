module Shapado
  module Models
    module Trackable
      extend ActiveSupport::Concern

      included do
        after_create :__on_create
        after_update :__on_update
        after_destroy :__on_destroy
      end

      module InstanceMethods
        private
        def __generate_trackable_info
          info = {}
          relations = self.class.relations
          self.class.trackeable_info[:fields].each do |f|
            if relations.has_key?(f.to_s)
              lookup = self.send(f)
              if lookup.respond_to?("name")
                info[f] = lookup.send("name")
              else
                info[f] = lookup["login"] || lookup["user_name"] || lookup["title"] || lookup["description"]
              end

              info["#{f}_id"] = lookup.id
              info["#{f}_param"] = lookup.to_param
            else
              info[f] = self[f]
            end
          end

          info
        end

        def __resolve_trackable_scope
          scope_fields = self.class.trackeable_info[:scope]
          scope_fields = [scope_fields] if !scope_fields.is_a?(Array)

          scope = {}
          scope_fields.each do |f|
            scope[f] = self[f]
          end

          scope
        end

        def __on_create
          __create_activity("create")
        end

        def __on_update
          __create_activity("update")
        end

        def __on_destroy
          __create_activity("destroy")
        end

        def __create_activity(action, opts = {})
          Rails.logger.info "Adding #{action} activity for #{self.class}"
          Activity.create!(opts.merge({
            :action => action,
            :trackable_info => __generate_trackable_info,
            :scope => __resolve_trackable_scope,
            :group_id => self[:group_id] || Thread.current[:current_group].try(:id),
            :user_id => Thread.current[:current_user].try(:id) || self[:user_id],
            :trackable => self,
            :user_ip => Thread.current[:current_ip]
          }))
        end
      end

      module ClassMethods
        def track_activities(*args)
          options = args.extract_options!

          trackeable_info[:fields] = args
          trackeable_info[:scope] = options[:scope]
        end

        def trackeable_info
          @trackeable_info ||= {}
        end
      end
    end
  end
end
