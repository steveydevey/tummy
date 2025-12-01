// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"

// Auto-populate datetime-local fields with current date/time if empty
function autopopulateDatetimeFields() {
  const datetimeFields = document.querySelectorAll('input[type="datetime-local"]');
  datetimeFields.forEach(function(field) {
    if (!field.value) {
      const now = new Date();
      // Format as YYYY-MM-DDTHH:mm for datetime-local input
      const year = now.getFullYear();
      const month = String(now.getMonth() + 1).padStart(2, '0');
      const day = String(now.getDate()).padStart(2, '0');
      const hours = String(now.getHours()).padStart(2, '0');
      const minutes = String(now.getMinutes()).padStart(2, '0');
      field.value = `${year}-${month}-${day}T${hours}:${minutes}`;
    }
  });
}

// Run on initial page load
document.addEventListener('DOMContentLoaded', autopopulateDatetimeFields);

// Run on Turbo page loads (for SPA-like navigation)
document.addEventListener('turbo:load', autopopulateDatetimeFields);
