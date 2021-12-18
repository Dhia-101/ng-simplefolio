
# Stage 1: Compile and Build angular codebase

# Use official node image as the base image
FROM node:14 as build

ARG PORT

# Set the working directory
WORKDIR /usr/local/app

# Add the source code to app
COPY ./ /usr/local/app/

# Install all the dependencies
RUN npm install

# Generate the build of the application
RUN npm run build


# Stage 2: Serve app with nginx server

# Use official nginx image as the base image
FROM nginx:latest

# Copy the build output to replace the default nginx contents.
COPY --from=build /usr/local/app/dist/ng-simplefolio /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf
# Expose port 80
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
