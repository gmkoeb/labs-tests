task :run_docker_containers do
  begin
    sh 'docker stop labs-tests postgres'
  rescue => e
    puts e
  end
  Dir.chdir('./api') do
    sh 'docker run --rm --name labs-tests --network rebase_labs -w /app -v $(pwd):/app -p 3000:3000 -d ruby bash -c "gem install rspec rackup sinatra puma pg && ruby server.rb"'
    sh 'docker run --rm --name postgres --network rebase_labs -v pgdata:/var/lib/postgresql/data -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres'
  end
end
