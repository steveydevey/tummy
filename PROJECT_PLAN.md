# Gitrack - Food & GI Issues Tracker

## Project Overview

A multi-user web application for tracking food intake and gastrointestinal issues. Built with Ruby on Rails, designed for containerized deployment on personal infrastructure.

## Technology Stack

- **Framework**: Ruby on Rails 7.x
- **Database**: SQLite (development/test), with option to migrate to PostgreSQL for production
- **Testing**: RSpec (or Minitest)
- **Containerization**: Docker
- **Authentication**: Devise (or similar)
- **Frontend**: Rails views with modern CSS (Tailwind CSS or similar)

## Core Features

### Phase 1: Foundation
- [x] Project initialization
- [ ] User authentication (login, logout)
- [ ] User profiles (created by admin)
- [ ] Basic dashboard

### Phase 2: Core Tracking
- [ ] Food entry tracking
  - Date/time
  - Food items/meals
  - Notes
- [ ] Bowel Movement tracking
  - Date/time
  - Description (from a list)
- [ ] GI symptoms tracking
  - Date/time
  - Symptom types (nausea, pain, bloating, etc.)
  - Severity levels
  - Notes
- [ ] Food-symptom correlation views

### Phase 3: Analysis & Insights
- [ ] Timeline view of food and symptoms
- [ ] Pattern detection
- [ ] Reports and statistics
- [ ] Export functionality

### Phase 4: Multi-user Features
- [ ] User isolation (users can only see their own data)
- [ ] Optional sharing/collaboration features
- [ ] Admin panel (if needed)

## Project Structure

```
gitrack/
├── .cursor/
│   └── rules/
│       └── rails-project.mdc
├── app/
│   ├── models/
│   │   ├── user.rb
│   │   ├── food_entry.rb
│   │   └── gi_symptom.rb
│   ├── controllers/
│   │   ├── dashboard_controller.rb
│   │   ├── food_entries_controller.rb
│   │   └── gi_symptoms_controller.rb
│   └── views/
├── config/
├── db/
│   ├── migrate/
│   └── schema.rb
├── spec/ (or test/)
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── PROJECT_PLAN.md
├── ARCHITECTURE.md
└── README.md
```

## Database Schema (Initial)

### Users
- id (primary key)
- email (unique, indexed)
- encrypted_password
- created_at, updated_at

### Food Entries
- id (primary key)
- user_id (foreign key, indexed)
- consumed_at (datetime)
- description (text)
- notes (text, optional)
- created_at, updated_at

### GI Symptoms
- id (primary key)
- user_id (foreign key, indexed)
- occurred_at (datetime)
- symptom_type (string/enum)
- severity (integer, 1-10)
- notes (text, optional)
- created_at, updated_at

## Testing Strategy

- **Unit Tests**: All models with validations and associations
- **Controller Tests**: All controller actions
- **Integration Tests**: User flows (login, create entries, view correlations)
- **System Tests**: End-to-end user scenarios
- Target: 90%+ code coverage

## Development Workflow

1. Write tests first (TDD approach)
2. Implement feature
3. Ensure all tests pass
4. Refactor if needed
5. Document changes

## Deployment

- Docker container with Rails app
- SQLite database (or migrate to PostgreSQL for production)
- Environment variables for configuration
- Health check endpoint

## Security Considerations

- User authentication required for all actions
- User data isolation (scoped queries)
- Input validation and sanitization
- CSRF protection (Rails default)
- SQL injection prevention (ActiveRecord)

## Next Steps

1. ✅ Initialize Rails project
2. ✅ Set up testing framework
3. ✅ Configure Docker
4. Set up authentication
5. Create User model and migrations
6. Create FoodEntry model and migrations
7. Create GISymptom model and migrations
8. Build controllers and views
9. Add tests for each component
10. Deploy to container

