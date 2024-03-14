build_api: 
	docker build -t labs-tests .
run_api: build_api
	docker run --rm --name labs-tests --network rebase_labs -p 3000:3000 -v $(PWD)/api:/app -d labs-tests
run_db:
	docker run --rm --name postgres --network rebase_labs -v pgdata:/var/lib/postgresql/data -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
run_web:
	docker run --rm --name web --network rebase_labs -w /app -v $(PWD)/web:/app -p 3001:3001 -d ruby bash -c "gem install rackup sinatra puma && ruby routes.rb"
run_redis:
	docker run --rm --name redis --network rebase_labs -d redis
run_sidekiq:
	docker run --rm --name sidekiq --network rebase_labs \
		-w /app \
		-v $(PWD)/api:/app \
		-e REDIS_URL=redis://redis:6379/0 \
		-d ruby \
		bash -c "gem install sidekiq pg && sidekiq -r ./jobs/data_conversion_job.rb"
run_containers: run_db build_api run_api run_web run_redis run_sidekiq
stop_containers: 
	docker stop labs-tests postgres web redis sidekiq