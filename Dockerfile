ARG NODE_VERSION=22.13.0

# Use node image for base image for all stages.
FROM node:${NODE_VERSION}-alpine as base

# Set working directory for all build stages.
WORKDIR /usr/src/app

# Copy package files and install dependencies.
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the source files.
COPY . .

# Build argument for port (set during build time)
ARG BUILD_PORT=3000
ENV PORT_DOCKER=${BUILD_PORT}

# Stage for running tests
FROM base as test

# Install testing dependencies
RUN npm install --save-dev jest @testing-library/react @testing-library/jest-dom

# Run Jest tests
RUN npx jest

# Final stage - Production build
FROM base as production

# Remove unnecessary dependencies
RUN npm prune --production

# Build the application.
RUN npx next build

# Expose the port dynamically
EXPOSE $PORT_DOCKER

# Print the GitHub Actions variable SMS before starting the app
CMD echo "SMS Message: $SMS" && npx next start
