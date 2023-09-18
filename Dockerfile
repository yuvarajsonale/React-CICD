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

# Copy package.json and package-lock.json from the first stage
COPY --from=build /app/package*.json ./

# Install craco as a development dependency
RUN npm install --save-dev @craco/craco

# Update the npm start script to use craco
RUN sed -i 's/react-scripts start/craco start/' package.json

# Expose port 3000 for the React app
EXPOSE 3000

# Start the React app using "npm start"
CMD ["npm", "start"]
