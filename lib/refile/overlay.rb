require 'refile'
require 'refile/overlay/version'

module Refile
  module Overlay
    # A backend which overlays one backend over another
    #
    # The _primary_ backend is accessed first: if a file requested exists here,
    # it is returned as usual. If it does not exist, the _secondary_ backend is
    # queried. New files will always be created on the primary backend.
    # In this fashion, the primary backend always overrides the secondary,
    # acting like a [union mount](https://en.wikipedia.org/wiki/Union_mount)
    class Backend
      attr_reader :primary
      attr_reader :secondary

      def initialize(primary, secondary)
        # TODO: check primary & secondary are really a backend
        @primary = primary
        @secondary = secondary
      end

      # Upload a file into this backend
      #
      # @param [IO] uploadable      An uploadable IO-like object.
      # @return [Refile::File]      The uploaded file
      def upload(uploadable)
        primary.upload(uploadable)
      end

      def get(id)
        Refile::File.new(self, id)
      end

      def delete(id)
        b = backend_for(id)
        b.delete(id) if b == @primary
      end

      def open(id)
        b = backend_for(id)
        b.open(id) if b
      end

      def read(id)
        b = backend_for(id)
        b.read(id) if b
      end

      def size(id)
        b = backend_for(id)
        b.size(id) if b
      end

      def exists?(id)
        backend_for(id) != nil
      end

      def clear!(confirm = nil)
        @primary.clear!(confirm)
      end

      def max_size
        @primary.max_size
      end

      private

      def backend_for(id)
        return @primary if primary.exists?(id)
        return @secondary if secondary.exists?(id)
        nil
      end
    end
  end
end
