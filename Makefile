##
## EPITECH PROJECT, 2024
## SURVIVOR
## File description:
## Makefile
##

# Target: client-build
# Description: Builds the client
client-build:
	cd client && flutter build

# Target: client-clean
# Description: Cleans the client build
client-clean:
	cd client && flutter clean

# Target: client-run
# Description: Runs the client in debug mode
client-run:
	cd client && flutter run -d chrome --web-browser-flag --disable-web-security

# Target: client-run-prod
# Description: Runs the client in production mode
client-run-prod:
	cd client && flutter run -d chrome --web-browser-flag --disable-web-security --release

# Target: server-install
# Description: Installs server dependencies
server-install:
	cd server && npm install

# Target: server-pm2-dev
# Description: Restarts the server in development mode using PM2
server-pm2-dev:
	cd server && pm2 reload ecosystem.config.js --only soul-connection-api-dev --env development

# Target: server-pm2-prod
# Description: Restarts the server in production mode using PM2
server-pm2-prod:
	cd server && pm2 reload ecosystem.config.js --only soul-connection-api-prod --env production

# Target: server
# Description: Runs the server in development mode
server:
	cd server && npm run dev

# Target: server-prod
# Description: Runs the server in production mode
server-prod:
	cd server && npm run start

# Target: server-lint
# Description: Runs the linter on the server code
server-lint:
	cd server && npm run lint

# Target: server-lint-fix
# Description: Runs the linter on the server code and fixes the issues
server-lint-fix:
	cd server && npm run lintfix

# Target: server-test
# Description: Runs the tests for the server code
server-test:
	cd server && npm run test

# Phony target: build
# Description: Builds the project
.PHONY: build

# Phony target: clean
# Description: Cleans the project
.PHONY: clean

# Phony target: run
# Description: Runs the project
.PHONY: run

# Phony target: server
# Description: Runs the server
.PHONY: server