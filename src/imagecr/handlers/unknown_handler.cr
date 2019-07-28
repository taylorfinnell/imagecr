module Imagecr
  module Handlers
    # Handlers for image types `Engine` does not understand.
    class UnknownHandler < Handler
      def parse_image
        nil
      end

      def verify_remaining_header
        nil
      end
    end
  end
end
