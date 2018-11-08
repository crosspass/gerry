require 'cgi'

module Gerry
  module Api
    module Changes
      # Get changes visible to the caller.
      #
      # @param [Array] options the query parameters.
      # @return [Hash] the changes.
      def changes(options = [])
        endpoint = '/changes/'
        url = endpoint

        if !options.empty?
          url += '?' + map_options(options)
        end

        response = get(url)
        return response if response.empty? || !response.last.delete('_more_changes')

        # Get the original start parameter, if any, else start from 0.
        query = URI.parse(url).query
        query = query ? CGI.parse(query) : { 'S' => ['0'] }
        start = query['S'].join.to_i

        # Keep getting data until there are no more changes.
        loop do
          # Replace the start parameter, using the original start as an offset.
          query['S'] = ["#{start + response.size}"]
          url = endpoint + '?' + map_options(query)

          response.concat(get(url))
          return response if response.empty? || !response.last.delete('_more_changes')
        end
      end

      def change(change_id)
        url = "/changes/#{change_id}"
        get(url)
      end

      def change_create(change)
        url = '/changes/'
        post(url, change.to_json)
      end

      def change_detail(change_id)
        url = "/changes/#{change_id}/detail"
        get(url)
      end

      def change_edit(change_id)
        url = "/changes/#{change_id}/edit"
        get(url)
      end

      def change_file(change_id, path, file)
        url = "/changes/#{change_id}/edit/#{path}"
        put(url, body: File.read(file))
      end

      def change_submit(change_id, options)
        url = "/changes/#{change_id}/submit"
        post(url, options.to_json)
      end

      def change_cherry_pick(change_id, revision, options)
        url = "/changes/#{change_id}/revisions/#{revision}/cherrypick"
        post(url, options.to_json)
      end
    end
  end
end
