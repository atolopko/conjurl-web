Conjurl Web App - URL shortener web app

# Overview

- Takes long URLs and providers a shorter URL that will redirect back
  to the original URL. The shortened URL can then be used anywhere!
- A user account can be created to manage and track the usage of your
  shortened URLs.
- For account-associated shortened URLs, reports statistics for click
  counts, referrer URLs, and referrer IP addresses for last 24 hours
  and lifetime of shortened URL.
- Easily deployable to AWS Elastic Beanstalk.


# Development

## Dependencies

- Ruby 2.2.3
- Rails 5.0.2
- [Conjurl API](https://github.com/atolopko/conjurl-api)

## Run server (localhost)

First, make sure you have the Conjurl (API) server running on port 3001. Then simply start this web server:

```
$ rails server
```

# Production Deployment Instructions

## Using AWS Elastic Beanstalk:

Install Elastic Beanstalk CLI. Instructions [here](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html).

Run the following from the project directory to deploy the latest Git-committed changes to a new AWS Elastic Beanstalk environment:
```
$ eb create conjurlweb-prod --single -i t2.micro -r us-east-2 --keyname conjurl-prod --platform 'ruby-2.3-(puma)'
$ eb setenv SECRET_KEY_BASE=`rails secret` \
DOMAIN_NAME=http://`eb status | grep CNAME: | awk '{ print $2 }'` \
CONJURL_JWT_SECRET=<YOUR_SUPER_SECURE_JWT_SECRET> \
API_BASE_URL=http://<CONJURL_HOST>/api
```

Notes:
- `YOUR_SUPER_SECURE_JWT_SECRET` must match the Conjurl server value.
- `CONJURL_HOST` can be found by running `eb status | grep CNAME: | awk '{ print $2 }'` from the Conjurl (API) project directory.

To deploy Git-committed updates to the current AWS Elastic Beanstalk environment:
```
$ eb deploy
```
