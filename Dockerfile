# Dockerfile
FROM ruby:3.1.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the app
COPY . .

# Precompile assets (if necessary)


# Expose port 3000 for the app
EXPOSE 3000

RUN bundle install

RUN chmod +x bin/setup
RUN chmod +x bin/rails


# Start the Rails app
CMD ["rails", "server"]
