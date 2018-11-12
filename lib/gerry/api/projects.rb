module Gerry
  module Api
    module Projects
      # Get the projects accessible by the caller.
      #
      # @return [Hash] the projects.
      def projects
        get('/projects/')
      end

      # Get the projects that start with the specified prefix
      # and accessible by the caller.
      #
      # @param [String] name the project name.
      # @return [Hash] the projects.
      def find_project(name)
        get("/projects/#{CGI.escape(name)}")
      end

      ##
      # Retrieves the description of a project.
      def project_description(project)
        get("/projects/#{CGI.escape(project)}/description")
      end

      # Get the symbolic HEAD ref for the specified project.
      #
      # @param [String] project the project name.
      # @return [String] the current ref to which HEAD points to.
      def get_head(project)
        get("/projects/#{CGI.escape(project)}/HEAD")
      end

      # Set the symbolic HEAD ref for the specified project to
      # point to the specified branch.
      #
      # @param [String] project the project name.
      # @param [String] branch the branch to point to.
      # @return [String] the new ref to which HEAD points to.
      def set_head(project, branch)
        url = "/projects/#{CGI.escape(project)}/HEAD"
        body = {
          ref: 'refs/heads/' + branch
        }
        put(url, body)
      end

      ##
      # lists the access rights for signle project
      def project_access(project)
        get("/projects/#{CGI.escape(project)}/access")
      end

      def create_project_access(project, permissions)
        access = {
          'add' => permissions
        }
        post("/projects/#{CGI.escape(project)}/access", access)
      end

      def remove_project_access(project, permissions)
        access = {
          'remove' => permissions
        }
        post("/projects/#{CGI.escape(project)}/access", access)
      end

      ##
      # Retrieves a commit of a project.
      def project_commit(project, commit_id)
        get("/projects/#{CGI.escape(project)}/commits/#{commit_id}")
      end
    end
  end
end
