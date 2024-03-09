build_api:
	docker run \
	 --rm \
	 --name labs-tests \
	 --network rebase_labs \
	 -w /app \
	 -v $(PWD)/api:/app \
	 -e REDIS_URL=redis://redis:6379/0 \
	 -p 3000:3000 \
	 -d ruby \
	 bash -c "apt-get update -y && apt-get install -y chromium-driver && gem install rspec multipart-post capybara sidekiq cuprite rackup sinatra puma pg && ruby server.rb"
build_db:
	docker run --rm --name postgres --network rebase_labs -v pgdata:/var/lib/postgresql/data -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
build_web:
	docker run --rm --name web --network rebase_labs -w /app -v $(PWD)/web:/app -p 3001:3001 -d ruby bash -c "gem install rackup sinatra puma && ruby routes.rb"
build_redis:
	docker run --rm --name redis --network rebase_labs -d redis
build_sidekiq:
	docker run --rm --name sidekiq --network rebase_labs \
		-w /app \
		-v $(PWD)/api:/app \
		-e REDIS_URL=redis://redis:6379/0 \
		-d ruby \
		bash -c "gem install sidekiq pg && sidekiq -r ./jobs/data_conversion_job.rb"
build_containers: build_api build_db build_web build_redis build_sidekiq
stop_containers: 
	docker stop labs-tests postgres web redis sidekiq