# Tummy Architecture

## System Architecture

### Application Layer
- **Rails MVC**: Standard Rails architecture
- **Controllers**: Handle HTTP requests, coordinate between models and views
- **Models**: Business logic, validations, associations
- **Views**: Presentation layer (ERB templates)

### Data Layer
- **SQLite**: Primary database for development and testing
- **ActiveRecord**: ORM for database interactions
- **Migrations**: Version-controlled schema changes

### Testing Layer
- **RSpec**: BDD-style testing framework
- **FactoryBot**: Test data generation
- **Shoulda Matchers**: Model validation testing
- **Capybara**: Integration/system testing

### Containerization
- **Docker**: Application containerization
- **Multi-stage builds**: Optimize image size
- **Volume mounts**: For development database persistence

## Data Flow

### Food Entry Flow
1. User submits food entry form
2. Controller validates and creates FoodEntry record
3. Record associated with current_user
4. Redirect to dashboard with success message

### Symptom Entry Flow
1. User submits symptom entry form
2. Controller validates and creates GISymptom record
3. Record associated with current_user
4. Redirect to dashboard with success message

### Correlation View Flow
1. User requests timeline/correlation view
2. Controller fetches user's food entries and symptoms
3. Data sorted by datetime
4. View renders timeline with both types of entries

## Security Architecture

### Authentication
- Devise gem for user authentication
- Session-based authentication
- Password hashing (bcrypt)

### Authorization
- User-scoped queries (all queries filtered by current_user)
- Controller-level authorization checks
- No direct model access from views

### Data Isolation
```ruby
# Example: All queries scoped to current user
class FoodEntry < ApplicationRecord
  belongs_to :user
  
  scope :for_user, ->(user) { where(user: user) }
end

# In controllers
def index
  @food_entries = current_user.food_entries.order(consumed_at: :desc)
end
```

## API Design (Future)

If API endpoints are needed:
- RESTful routes
- JSON responses
- JWT authentication (optional)
- Rate limiting

## Performance Considerations

- Database indexes on foreign keys and datetime fields
- Pagination for large datasets
- Eager loading to prevent N+1 queries
- Caching for frequently accessed data (future)

## Scalability

- SQLite suitable for single-user or small multi-user deployments
- Can migrate to PostgreSQL for larger scale
- Stateless application design (container-friendly)
- Horizontal scaling possible with shared database

