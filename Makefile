# Docker Homelab Makefile
# Manages services organized by function
.PHONY: help up down restart logs status ps clean

# Load environment variables
include .env
export $(shell sed 's/=.*//' .env)

# Default target
help:
	@echo "Docker Homelab Management"
	@echo "========================="
	@echo ""
	@echo "Service Groups:"
	@echo "  core       - Essential infrastructure (homeassistant, frigate, zwave, portainer)"
	@echo "  media      - Media server stack (jellyfin, *arr services)"
	@echo "  monitoring - Observability (dozzle, speedtest)"
	@echo "  utilities  - Support services (heimdall, duplicati, watchtower)"
	@echo "  all        - All services"
	@echo ""
	@echo "Commands:"
	@echo "  up GROUP          - Start services in group"
	@echo "  down GROUP        - Stop services in group"
	@echo "  restart GROUP     - Restart services in group"
	@echo "  logs GROUP        - Show logs for services in group"
	@echo "  status GROUP      - Show status of services in group"
	@echo "  ps                - Show all running containers"
	@echo "  clean             - Remove stopped containers and unused images"
	@echo ""
	@echo "Examples:"
	@echo "  make up core      - Start core services"
	@echo "  make logs media   - Show media service logs"
	@echo "  make restart all  - Restart all services"

# Service definitions
CORE_SERVICES = homeassistant frigate zwave portainer
MEDIA_SERVICES = jellyfin sonarr radarr bazarr prowlarr sabnzbd jellyseerr
MONITORING_SERVICES = dozzle speedtest
UTILITIES_SERVICES = heimdall duplicati watchtower changedetection mosquitto bookstack pihole-unbound

# Core services
up-core:
	@echo "Starting core services..."
	@for service in $(CORE_SERVICES); do \
		if [ -f "services/core/$$service/compose.yaml" ]; then \
			echo "Starting $$service..."; \
			cd services/core/$$service && docker compose up -d && cd ../../..; \
		else \
			echo "Warning: services/core/$$service/compose.yaml not found"; \
		fi; \
	done

down-core:
	@echo "Stopping core services..."
	@for service in $(CORE_SERVICES); do \
		if [ -f "services/core/$$service/compose.yaml" ]; then \
			echo "Stopping $$service..."; \
			cd services/core/$$service && docker compose down && cd ../../..; \
		fi; \
	done

restart-core: down-core up-core

logs-core:
	@echo "Showing logs for core services..."
	@for service in $(CORE_SERVICES); do \
		if [ -f "services/core/$$service/compose.yaml" ]; then \
			echo "=== $$service logs ==="; \
			cd services/core/$$service && docker compose logs --tail=20 && cd ../../..; \
		fi; \
	done

status-core:
	@echo "Core services status:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=homeassistant" --filter "name=frigate" --filter "name=zwave" --filter "name=portainer"

# Media services
up-media:
	@echo "Starting media services..."
	@for service in $(MEDIA_SERVICES); do \
		if [ -f "services/media/$$service/compose.yaml" ]; then \
			echo "Starting $$service..."; \
			cd services/media/$$service && docker compose up -d && cd ../../..; \
		else \
			echo "Warning: services/media/$$service/compose.yaml not found"; \
		fi; \
	done

down-media:
	@echo "Stopping media services..."
	@for service in $(MEDIA_SERVICES); do \
		if [ -f "services/media/$$service/compose.yaml" ]; then \
			echo "Stopping $$service..."; \
			cd services/media/$$service && docker compose down && cd ../../..; \
		fi; \
	done

restart-media: down-media up-media

logs-media:
	@echo "Showing logs for media services..."
	@for service in $(MEDIA_SERVICES); do \
		if [ -f "services/media/$$service/compose.yaml" ]; then \
			echo "=== $$service logs ==="; \
			cd services/media/$$service && docker compose logs --tail=10 && cd ../../..; \
		fi; \
	done

status-media:
	@echo "Media services status:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=jellyfin" --filter "name=sonarr" --filter "name=radarr" --filter "name=bazarr" --filter "name=prowlarr" --filter "name=sabnzbd" --filter "name=jellyseerr"

# Monitoring services
up-monitoring:
	@echo "Starting monitoring services..."
	@for service in $(MONITORING_SERVICES); do \
		if [ -f "services/monitoring/$$service/compose.yaml" ]; then \
			echo "Starting $$service..."; \
			cd services/monitoring/$$service && docker compose up -d && cd ../../..; \
		else \
			echo "Warning: services/monitoring/$$service/compose.yaml not found"; \
		fi; \
	done

down-monitoring:
	@echo "Stopping monitoring services..."
	@for service in $(MONITORING_SERVICES); do \
		if [ -f "services/monitoring/$$service/compose.yaml" ]; then \
			echo "Stopping $$service..."; \
			cd services/monitoring/$$service && docker compose down && cd ../../..; \
		fi; \
	done

restart-monitoring: down-monitoring up-monitoring

logs-monitoring:
	@echo "Showing logs for monitoring services..."
	@for service in $(MONITORING_SERVICES); do \
		if [ -f "services/monitoring/$$service/compose.yaml" ]; then \
			echo "=== $$service logs ==="; \
			cd services/monitoring/$$service && docker compose logs --tail=10 && cd ../../..; \
		fi; \
	done

status-monitoring:
	@echo "Monitoring services status:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=grafana" --filter "name=prometheus" --filter "name=dozzle" --filter "name=speedtest"

# Utilities services
up-utilities:
	@echo "Starting utilities services..."
	@for service in $(UTILITIES_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "Starting $$service..."; \
			cd services/utilities/$$service && docker compose up -d && cd ../../..; \
		else \
			echo "Warning: services/utilities/$$service/compose.yaml not found"; \
		fi; \
	done

down-utilities:
	@echo "Stopping utilities services..."
	@for service in $(UTILITIES_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "Stopping $$service..."; \
			cd services/utilities/$$service && docker compose down && cd ../../..; \
		fi; \
	done

restart-utilities: down-utilities up-utilities

logs-utilities:
	@echo "Showing logs for utilities services..."
	@for service in $(UTILITIES_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "=== $$service logs ==="; \
			cd services/utilities/$$service && docker compose logs --tail=10 && cd ../../..; \
		fi; \
	done

status-utilities:
	@echo "Utilities services status:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=heimdall" --filter "name=duplicati" --filter "name=watchtower" --filter "name=changedetection" --filter "name=mosquitto"

# All services
up-all: up-core up-media up-monitoring up-utilities
down-all: down-utilities down-monitoring down-media down-core
restart-all: down-all up-all
logs-all: logs-core logs-media logs-monitoring logs-utilities
status-all: status-core status-media status-monitoring status-utilities

# Generic targets that accept GROUP parameter
up:
	@$(MAKE) up-$(filter-out up,$(MAKECMDGOALS))

down:
	@$(MAKE) down-$(filter-out down,$(MAKECMDGOALS))

restart:
	@$(MAKE) restart-$(filter-out restart,$(MAKECMDGOALS))

logs:
	@$(MAKE) logs-$(filter-out logs,$(MAKECMDGOALS))

status:
	@$(MAKE) status-$(filter-out status,$(MAKECMDGOALS))

# Utility commands
ps:
	@docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

clean:
	@echo "Cleaning up stopped containers and unused images..."
	@docker container prune -f
	@docker image prune -f
	@echo "Cleanup complete!"

# Prevent make from treating service names as files
%:
	@: 