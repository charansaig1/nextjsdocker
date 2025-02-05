
ARG NODE_VERSION=22.13.0

# Use node image for base image for all stages.
FROM node:${NODE_VERSION}-alpine as base

# Set working directory for all build stages.
WORKDIR /usr/src/app


# Copy package.json and package-lock.json
COPY package.json package-lock.json ./


# Install dependencies
RUN npm install


# Copy the rest of the source files into the image.
COPY . .


# Run the build script.
RUN npm run build



# Expose the port that the application listens on.
EXPOSE 3000

# Run the application.
CMD npx start
