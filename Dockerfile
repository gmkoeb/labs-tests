FROM ruby

WORKDIR /app

RUN apt-get update -y \
    && apt-get install -y chromium-driver \
    && gem install rspec multipart-post capybara sidekiq cuprite rackup sinatra puma pg

COPY api /app

ENV REDIS_URL=redis://redis:6379/0

EXPOSE 3000

CMD ["bash", "-c", "ruby server.rb"]
