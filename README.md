# Tummy - Food & GI Issues Tracker

A multi-user web application for tracking food intake and gastrointestinal issues. Built with Ruby on Rails, designed for containerized deployment.

## Features

- **Multi-user support**: Each user can track their own food and symptoms
- **Food tracking**: Log meals and food items with timestamps and notes
- **GI symptom tracking**: Record gastrointestinal symptoms with severity levels
- **Correlation analysis**: View timeline of food and symptoms to identify patterns
- **Secure**: User authentication and data isolation

## Technology Stack

- **Framework**: Ruby on Rails 8.1
- **Database**: SQLite (development/test), can migrate to PostgreSQL for production
- **Testing**: RSpec with FactoryBot and Shoulda Matchers
- **Containerization**: Docker with docker-compose support

## Prerequisites

- Ruby 3.4.7
- Bundler
- Docker and Docker Compose (for containerized deployment)
- SQLite3

## Getting Started

### Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd tummy
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Set up the database**
   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Start the Rails server**
   ```bash
   rails server
   ```

   The application will be available at `http://localhost:3000`

### Docker Deployment

1. **Build and run with Docker Compose**
   ```bash
   docker-compose up --build
   ```

   The application will be available at `http://localhost:3000`

2. **Or build and run manually**
   ```bash
   docker build -t tummy .
   docker run -d -p 3000:80 \
     -e RAILS_MASTER_KEY=$(cat config/master.key) \
     -v $(pwd)/db/production.sqlite3:/rails/db/production.sqlite3 \
     --name tummy tummy
   ```

## Testing

Run the test suite:

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/user_spec.rb

# Run with coverage (if simplecov is added)
bundle exec rspec
```

## Project Structure

```
tummy/
├── app/
│   ├── models/          # ActiveRecord models
│   ├── controllers/     # Application controllers
│   ├── views/           # ERB templates
│   └── helpers/         # View helpers
├── config/              # Application configuration
├── db/
│   ├── migrate/         # Database migrations
│   └── schema.rb        # Database schema
├── spec/                # RSpec tests
│   ├── models/          # Model specs
│   ├── controllers/     # Controller specs
│   ├── requests/        # Request specs
│   └── factories/       # FactoryBot factories
├── .cursor/
│   └── rules/           # Cursor IDE rules
├── Dockerfile           # Docker configuration
├── docker-compose.yml   # Docker Compose configuration
├── PROJECT_PLAN.md      # Detailed project plan
└── ARCHITECTURE.md      # System architecture documentation
```

## Development Workflow

1. **Write tests first** (TDD approach)
2. **Implement the feature**
3. **Ensure all tests pass**
4. **Refactor if needed**
5. **Update documentation**

## Database

The application uses SQLite by default. The database file is located at:
- Development: `db/development.sqlite3`
- Test: `db/test.sqlite3`
- Production: `db/production.sqlite3`

### Migrations

Create a new migration:
```bash
rails generate migration CreateUsers email:string encrypted_password:string
```

Run migrations:
```bash
rails db:migrate
```

Rollback last migration:
```bash
rails db:rollback
```

## Security

- User authentication required for all actions
- User data isolation (all queries scoped to current_user)
- Input validation and sanitization
- CSRF protection (Rails default)
- SQL injection prevention (ActiveRecord)

## Environment Variables

- `RAILS_ENV`: Rails environment (development, test, production)
- `RAILS_MASTER_KEY`: Master key for encrypted credentials (required in production)

## Contributing

1. Write tests for all new features
2. Follow Ruby style guide
3. Keep controllers and models thin
4. Document complex logic
5. Update PROJECT_PLAN.md as features are completed

## License

[Your License Here]

## Support

For issues and questions, please open an issue in the repository.
