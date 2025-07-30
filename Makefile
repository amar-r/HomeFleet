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
	@echo "Utility Subsets:"
	@echo "  networking - DNS services (pihole-unbound)"
	@echo "  backup     - Backup services (duplicati)"
	@echo "  monitoring-utils - Monitoring utilities (watchtower, changedetection)"
	@echo "  communication - Communication services (mosquitto)"
	@echo "  web        - Web services (heimdall, bookstack)"
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
	@echo "  make restart networking - Restart Pi-hole and Unbound only"
	@echo "  make up backup    - Start backup services only"

# Service definitions
CORE_SERVICES = homeassistant frigate zwave portainer
MEDIA_SERVICES = jellyfin sonarr radarr bazarr prowlarr sabnzbd jellyseerr
MONITORING_SERVICES = dozzle speedtest
UTILITIES_SERVICES = heimdall duplicati watchtower changedetection mosquitto bookstack pihole-unbound

# Subset definitions for more granular control
NETWORKING_SERVICES = pihole-unbound
BACKUP_SERVICES = duplicati
MONITORING_UTILITIES = watchtower changedetection
COMMUNICATION_SERVICES = mosquitto
WEB_SERVICES = heimdall bookstack

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

# Networking services (Pi-hole + Unbound)
up-networking:
	@echo "Starting networking services..."
	@for service in $(NETWORKING_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "Starting $$service..."; \
			cd services/utilities/$$service && docker compose up -d && cd ../../..; \
		else \
			echo "Warning: services/utilities/$$service/compose.yaml not found"; \
		fi; \
	done

down-networking:
	@echo "Stopping networking services..."
	@for service in $(NETWORKING_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "Stopping $$service..."; \
			cd services/utilities/$$service && docker compose down && cd ../../..; \
		fi; \
	done

restart-networking: down-networking up-networking

logs-networking:
	@echo "Showing logs for networking services..."
	@for service in $(NETWORKING_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "=== $$service logs ==="; \
			cd services/utilities/$$service && docker compose logs --tail=10 && cd ../../..; \
		fi; \
	done

status-networking:
	@echo "Networking services status:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=pihole" --filter "name=unbound"

# Backup services
up-backup:
	@echo "Starting backup services..."
	@for service in $(BACKUP_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "Starting $$service..."; \
			cd services/utilities/$$service && docker compose up -d && cd ../../..; \
		else \
			echo "Warning: services/utilities/$$service/compose.yaml not found"; \
		fi; \
	done

down-backup:
	@echo "Stopping backup services..."
	@for service in $(BACKUP_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "Stopping $$service..."; \
			cd services/utilities/$$service && docker compose down && cd ../../..; \
		fi; \
	done

restart-backup: down-backup up-backup

logs-backup:
	@echo "Showing logs for backup services..."
	@for service in $(BACKUP_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "=== $$service logs ==="; \
			cd services/utilities/$$service && docker compose logs --tail=10 && cd ../../..; \
		fi; \
	done

status-backup:
	@echo "Backup services status:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=duplicati"

# Monitoring utilities
up-monitoring-utils:
	@echo "Starting monitoring utilities..."
	@for service in $(MONITORING_UTILITIES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "Starting $$service..."; \
			cd services/utilities/$$service && docker compose up -d && cd ../../..; \
		else \
			echo "Warning: services/utilities/$$service/compose.yaml not found"; \
		fi; \
	done

down-monitoring-utils:
	@echo "Stopping monitoring utilities..."
	@for service in $(MONITORING_UTILITIES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "Stopping $$service..."; \
			cd services/utilities/$$service && docker compose down && cd ../../..; \
		fi; \
	done

restart-monitoring-utils: down-monitoring-utils up-monitoring-utils

logs-monitoring-utils:
	@echo "Showing logs for monitoring utilities..."
	@for service in $(MONITORING_UTILITIES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "=== $$service logs ==="; \
			cd services/utilities/$$service && docker compose logs --tail=10 && cd ../../..; \
		fi; \
	done

status-monitoring-utils:
	@echo "Monitoring utilities status:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=watchtower" --filter "name=changedetection"

# Communication services
up-communication:
	@echo "Starting communication services..."
	@for service in $(COMMUNICATION_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "Starting $$service..."; \
			cd services/utilities/$$service && docker compose up -d && cd ../../..; \
		else \
			echo "Warning: services/utilities/$$service/compose.yaml not found"; \
		fi; \
	done

down-communication:
	@echo "Stopping communication services..."
	@for service in $(COMMUNICATION_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "Stopping $$service..."; \
			cd services/utilities/$$service && docker compose down && cd ../../..; \
		fi; \
	done

restart-communication: down-communication up-communication

logs-communication:
	@echo "Showing logs for communication services..."
	@for service in $(COMMUNICATION_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "=== $$service logs ==="; \
			cd services/utilities/$$service && docker compose logs --tail=10 && cd ../../..; \
		fi; \
	done

status-communication:
	@echo "Communication services status:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=mosquitto"

# Web services
up-web:
	@echo "Starting web services..."
	@for service in $(WEB_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "Starting $$service..."; \
			cd services/utilities/$$service && docker compose up -d && cd ../../..; \
		else \
			echo "Warning: services/utilities/$$service/compose.yaml not found"; \
		fi; \
	done

down-web:
	@echo "Stopping web services..."
	@for service in $(WEB_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "Stopping $$service..."; \
			cd services/utilities/$$service && docker compose down && cd ../../..; \
		fi; \
	done

restart-web: down-web up-web

logs-web:
	@echo "Showing logs for web services..."
	@for service in $(WEB_SERVICES); do \
		if [ -f "services/utilities/$$service/compose.yaml" ]; then \
			echo "=== $$service logs ==="; \
			cd services/utilities/$$service && docker compose logs --tail=10 && cd ../../..; \
		fi; \
	done

status-web:
	@echo "Web services status:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=heimdall" --filter "name=bookstack"

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