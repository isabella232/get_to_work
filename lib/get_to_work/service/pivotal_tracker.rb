# frozen_string_literal: true

require "tracker_api"

module GetToWork
  class Service
    class PivotalTracker < GetToWork::Service
      @yaml_key = "pivotal_tracker"
      @name = "PivotalTracker"
      @display_name = "Pivotal Tracker"

      def authenticate(username:, password:)
        @api_token = ::PivotalTracker::Client.token(username, password)
      end

      def authenticate_with_keychain
        if the_keychain = keychain
          set_client_token(the_keychain.password)
        end
      end

      def set_client_token(token)
        @api_token = token
      end

      def api_client
        @api_client ||= TrackerApi::Client.new(token: @api_token)
      end

      def projects
        @projects ||= get_projects
      end

      def get_projects
        ::PivotalTracker::Project.all
      end

      def story(story_id)
        api_client.project(@project_id).story(story_id)
      end
    end
  end
end
