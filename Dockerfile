# Start with alpine linux base image, latest since no version is defined
FROM alpine
MAINTAINER Eric Harris <eric@itfargo.com>

# Install dependencies for running the wttr.in API
RUN apk --no-cache add --update \
        bash \
        go \
        gawk \
        python \
        sed

# Install dependencies for building the wttr.in API
RUN apk --no-cache add --virtual build-deps \
        build-base \
        py-pip \
        python-dev \
        git

# Give the working directory for the wttr.in API
WORKDIR /app

# Install the wego terminal weather app, which wttr.in interfaces with
RUN go get -u github.com/schachmat/wego && \
    go install github.com/schachmat/wego

# Copy the wttr.in application code to the image, and the .wegorc file to /root
COPY . /app
COPY ./.wegorc /root

# Set environment variables needed for wttr.in to run
ENV WTTR_MYDIR="/app"
ENV WTTR_GEOLITE="/app/GeoLite2-City.mmdb"
ENV WTTR_WEGO="/root/go/bin/wego"
ENV WTTR_LISTEN_HOST="0.0.0.0"
ENV WTTR_LISTEN_PORT="8002"

# Install the python dependencies for wttr.in
RUN pip install -r requirements.txt

# Remove the build dependencies to save space
RUN apk del build-deps

# Expose port 8002 of the container for the application to use
EXPOSE 8002

# Final command to start the wttr.in API, log to /dev/null, and run in background
CMD ["nohup","python","bin/srv.py"," >> /dev/null 2>&1 &"]