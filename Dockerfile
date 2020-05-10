FROM nginx:stable

## Step 1:
RUN rm /usr/share/nginx/html/index.html

## Step 2:
# Copy source code to working directory
COPY index.html /usr/share/nginx/html

MAINTAINER "mywebsite2810@gmail.com"
