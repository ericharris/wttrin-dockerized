# Dockerized wttr.in API

This project is a fork of the wttr.in API at https://github.com/chubin/wttr.in.

## Changes to wttr.in

- A modification was made to the application code that prevented it from functioning. In `bin/srv.py` line 12, the following change needed to be made.
    ```
    - from gevent.wsgi import WSGIServer
    + from gevent.pywsgi import WSGIServer
    ```
- Added the file `.wegorc` that contains your weather API key
- Added the GeoLite2 geo-city database after extracting from http://geolite.maxmind.com

## Requirements

- Openweathermap.org API key
    - You will need to obtain an API key from openweathermap.org, and add it to the `.wegorc` file in this project. I have provided a temporary key for now.
- Docker installed - docker.com

## Create your docker image

You can create and test a docker image for the application using the below commands.

### Clone this repository to your local machine

```
git clone https://github.com/ericharris/wttrin-dockerized.git
```

### Build Docker image

```
docker image build -t wttr:v0.1 .
```

This command will build the image based on the Dockerfile in this repository, name the image `wttr` and tag it with `v0.1`.

### Test Docker image
You can test the image on your local machine before deploying to a container service.

```
docker container run -p 8002:8002 wttr:v0.1
```

This command will run the image you created, and make availble port 8002 to your machine from the image.

You should now be able to see `http://localhost:8002` in your browser, or from command line enter `curl http://localhost:8002`.

You can shut down the docker container by issueing a `CTRL-C` command.

## Future to-do
* move the geoip database to a download/unzip function in the Dockerfile to reduce size of this project and keep the db up to date
