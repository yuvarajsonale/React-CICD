# Stage 1: Build the React app
FROM node:16 AS build

WORKDIR /app

# Copy package.json and package-lock.json to cache dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Create a lightweight production image
FROM node:16-slim

WORKDIR /app

# Copy the built files from the previous stage
COPY --from=build /app/build ./build

# Expose port 3000 for the React app
EXPOSE 3000

# Start the React app
CMD ["node", "./build/index.js"]
