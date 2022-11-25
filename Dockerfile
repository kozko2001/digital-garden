## Base ########################################################################
# Use a larger node image to do the build for native deps (e.g., gcc, python)
FROM node:lts as base

# We'll run the app as the `node` user, so put it in their home directory
WORKDIR /home/node/app
COPY . /home/node/app/

RUN npm install
RUN npm run build

# Use a stable nginx image
FROM nginx:stable-alpine as deploy
WORKDIR /home/node/app
# Copy what we've installed/built from production
COPY --from=base /home/node/app/build /usr/share/nginx/html/
