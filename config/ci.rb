# Run using bin/ci

CI.run do
  step "Setup", "bin/setup --skip-server"
  step "Tests: RSpec", "bundle exec rspec"
end
