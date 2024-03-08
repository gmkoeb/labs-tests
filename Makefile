build_api:
	docker run \
	 --rm \
	 --name labs-tests \
	 --network rebase_labs \
	 -w /app \
	 -v $(PWD)/api:/app \
	 -p 3000:3000 \
	 -d ruby \
	 bash -c "apt-get update -y && apt-get install -y chromium-driver && gem install rspec multipart-post capybara cuprite rackup sinatra puma pg && ruby server.rb"
build_db:
	docker run --rm --name postgres --network rebase_labs -v pgdata:/var/lib/postgresql/data -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
build_web:
	docker run --rm --name web --network rebase_labs -w /app -v $(PWD)/web:/app -p 3001:3001 -d ruby bash -c "gem install rackup sinatra puma && ruby routes.rb"
build_containers: build_api build_db build_web
stop_containers: 
	docker stop labs-tests postgres web