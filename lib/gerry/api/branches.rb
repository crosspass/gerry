# frozen_string_literal: true

module Gerry
  module Api
    module Branches
      ##
      # Get the branches of project
      #
      def branches(project)
        get(branch_path(project, nil))
      end

      # Get the projects that start with the specified prefix
      # and accessible by the caller.
      #
      # @param [String] name the project name.
      # @return [Hash] the projects.
      def branch(project, branch)
        get(branch_path(project, branch))
      end

      ##
      # create branch that derived from branch name or revision
      #
      #  example: create_branch('foo', 'master', 'stable')
      #           create_branch('foo', 'revision', 'stable')
      #
      def create_branch(project, source, branch)
        body = { ref: source }
        put(branch_path(project, branch), body)
      rescue Gerry::Api::Request::RequestError
        # try source as revision
        body = { revision: source }
        put(branch_path(project, branch), body)
      end

      ##
      # Gets the reflog of a certain branch.
      def branch_reflog(project, branch, number)
        get("#{branch_path(project, branch)}/#reflog?n=#{number}")
      end

      ##
      # Gets the content of a file from the HEAD revision of a certain branch.
      def branch_file_content(project, branch, file_path)
        get("#{branch_path(project, branch)}/files/#{CGI.escape(file_path)}/content")
      end

      private

      def branch_path(project, branch)
        "/projects/#{CGI.escape(project)}/branches/#{branch}"
      end
    end
  end
end
