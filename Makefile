.PHONY: init start stop logs exec db-create db-migrate deps 

no-cmd-specified:
	@echo "Usage: make COMMAND"
	@echo "  init				rebuild the project"
	@echo "  start				start project"
	@echo "  stop				stop project"
	@echo "  delete				delete project"
	@echo "  logs				tail project logs"
	@echo "  rails				expose app container rails bin"
	@echo "  exec				bash into app container"
	@echo "  check				checksum dependencies files"
	@echo "  db-create			rails create database"
	@echo "  db-migrate			rails run migrations"
	@echo "  console			open rails console"
	@echo "  deps				install app dependencies (bundle install)"

init:
	docker-compose down
	docker-compose up --build -d
start:
	docker-compose up -d
stop:
	docker-compose stop
delete:
	docker-compose down 

logs:
	docker-compose logs -f --tail 1000
rails:
	docker-compose run web $(MAKECMDGOALS)

exec:
	docker-compose run web bash 
check:
	sha256sum Dockerfile Gemfile docker-compose.yml | sha256sum | cut -d' ' -f1

db-create:
	$(MAKE) rails db:create 
db-migrate:
	$(MAKE) rails db:migrate
console:
	$(MAKE) rails console
deps:
	docker-compose run web bundle install
