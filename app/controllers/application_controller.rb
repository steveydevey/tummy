class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def sanitize_return_to(url)
    return nil if url.blank?
    
    begin
      # Handle both full URLs and paths
      url_string = url.to_s
      
      # If it's a full URL, extract just the path
      if url_string.include?('://')
        uri = URI.parse(url_string)
        path = uri.path
      else
        # It's already a path, but might have query params
        path = url_string.split('?').first
      end
      
      # Remove trailing slash for comparison
      path = path.chomp('/')
      
      # Get the exact safe index paths (no IDs, no edit, no new)
      safe_paths = {
        food_entries_path.chomp('/') => food_entries_path,
        gi_symptoms_path.chomp('/') => gi_symptoms_path,
        bowel_movements_path.chomp('/') => bowel_movements_path,
        root_path.chomp('/') => root_path,
        '/' => root_path
      }
      
      # Check if the path matches any safe path exactly
      # Reject paths that contain IDs (numbers after the last slash)
      if path.match?(/\d+$/) || path.include?('/edit') || path.include?('/new')
        return nil
      end
      
      # Only match if path is exactly one of the safe paths
      if safe_paths.key?(path)
        return safe_paths[path]
      end
      
      nil
    rescue URI::InvalidURIError, ArgumentError => e
      Rails.logger.debug "Error sanitizing return_to: #{e.message}"
      nil
    end
  end
end
