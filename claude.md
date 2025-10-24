# Claude Development Guidelines for Ryde

## Workflow Requirements

### Git Workflow
1. **Always create a new branch** for every task or feature
   - Branch naming: `feature/descriptive-name`, `fix/bug-description`, or `refactor/what-is-being-refactored`
   - Never commit directly to main

2. **Always open a Pull Request** when work is complete
   - Include clear PR description with summary and test plan
   - Reference any related issues
   - Ensure all tests pass before creating PR

## Code Quality Standards

### Sandi Metz' Rules
Follow these rules strictly (break only with good reason and documentation):

1. **Classes can be no longer than 100 lines of code**
2. **Methods can be no longer than 5 lines of code**
3. **Pass no more than 4 parameters into a method**
   - Use parameter objects or hash options if needed
4. **Controllers can instantiate only one object**
   - Use decorators, presenters, or service objects for additional logic

### Uncle Bob's Clean Code Principles

1. **Meaningful Names**
   - Use intention-revealing names
   - Avoid disinformation
   - Make meaningful distinctions
   - Use pronounceable and searchable names

2. **Functions**
   - Should do one thing
   - Should be small (ideally < 5 lines per Sandi Metz)
   - One level of abstraction per function
   - Use descriptive names

3. **DRY Principle**
   - Don't Repeat Yourself
   - Extract common logic into methods or modules

4. **Comments**
   - Code should be self-documenting
   - Comments explain WHY, not WHAT
   - Remove commented-out code

5. **Error Handling**
   - Use exceptions rather than return codes
   - Provide context with exceptions
   - Don't return nil

### Rails Conventions and Best Practices

1. **Follow Rails Way**
   - Convention over configuration
   - RESTful routing and resource-oriented design
   - Use Rails generators appropriately
   - Follow MVC architecture strictly

2. **Model Layer**
   - Fat models, skinny controllers (but not too fat - use service objects)
   - Use concerns for shared behavior
   - Validations and callbacks in models
   - Use scopes for common queries

3. **Controller Layer**
   - Keep controllers thin
   - One instance variable per action (Sandi Metz rule)
   - Use before_actions for common setup
   - Respond with appropriate HTTP status codes

4. **View Layer**
   - Logic-free views
   - Use helpers and decorators for view logic
   - Partials for reusable components

5. **Service Objects**
   - Extract complex business logic into service objects
   - One responsibility per service
   - Place in `app/services/`

6. **Database**
   - Always write migrations (both up and down)
   - Add indexes for foreign keys and frequently queried columns
   - Use database constraints where appropriate

### Frontend Development

1. **Bootstrap 5 Usage**
   - Use Bootstrap utility classes for layout and spacing
   - Leverage Bootstrap components (cards, buttons, forms, alerts, etc.)
   - Avoid inline styles - use Bootstrap classes or custom CSS
   - Reference: [Bootstrap 5 Documentation](https://getbootstrap.com/docs/5.3/)

2. **Custom Styling**
   - All custom styles go in `app/assets/stylesheets/`
   - Use CSS variables for theme colors (see `:root` in `ryde-theme.css`)
   - Follow the existing naming pattern: `--ryde-*` for custom variables
   - Override Bootstrap defaults using CSS variables when possible

3. **CSS Organization**
   - Files load alphabetically via Propshaft
   - Keep `ryde-theme.css` for theme-wide overrides only
   - Create component-specific CSS files if needed
   - Avoid `!important` unless absolutely necessary

4. **Responsive Design**
   - Mobile-first approach
   - Use Bootstrap's responsive grid system
   - Test on mobile, tablet, and desktop viewports
   - Use Bootstrap responsive utility classes (`d-none`, `d-md-block`, etc.)

5. **Asset Pipeline**
   - Images go in `app/assets/images/`
   - Use `image_tag` helper in views
   - SVG preferred for icons and logos
   - Optimize images before committing

## Testing Requirements

### Test Coverage
Write comprehensive tests for all functionality:

1. **Model Tests** (`test/models/`)
   - Validations
   - Associations
   - Scopes
   - Custom methods
   - Edge cases

2. **Controller Tests** (`test/controllers/`)
   - All actions
   - Authentication/authorization
   - Request parameters
   - Response formats
   - Error handling

3. **Integration/System Tests** (`test/integration/` or `test/system/`)
   - Critical user flows
   - Multi-step processes
   - End-to-end scenarios

4. **Service Object Tests**
   - Happy path
   - Error cases
   - Edge cases

### Test Quality
- Tests should be readable and maintainable
- Use descriptive test names
- Follow AAA pattern: Arrange, Act, Assert
- Use fixtures or factories appropriately
- Don't test framework functionality, test your code
- Aim for fast test suite

## Pull Request Checklist

Before creating a PR, ensure:
- [ ] All CI checks pass (`bin/ci`)
- [ ] Code follows Sandi Metz' rules
- [ ] Code follows clean code principles
- [ ] Rails conventions are followed
- [ ] New functionality has comprehensive tests
- [ ] No commented-out code
- [ ] No debugging statements (puts, console.log, etc.)
- [ ] Migrations are reversible
- [ ] Branch is up to date with main

## Documentation
- Update README.md if adding new features or changing setup
- Document complex business logic
- Add YARD/RDoc comments for public APIs
- Keep this claude.md updated with project-specific conventions
