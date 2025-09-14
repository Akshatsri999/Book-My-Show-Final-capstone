# Base image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy all source code
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the app, make sure it listens on 0.0.0.0
CMD ["node", "server.js"]
