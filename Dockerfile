FROM php:7.4-fpm

LABEL version="1.0"
LABEL maintriner="hamm.huang@gmail.com"

# Prevent dialog during apt install
ENV DEBIAN_FRONTEND noninteractive
ENV NODE_VERSION 14.17.3

# Install system dependencies
RUN apt-get update && apt-get install -y \
	bash \
	git \
	curl \
	wget \
	libpng-dev \
	libonig-dev \
	libxml2-dev \
	apt-utils \
	libzip-dev \
	libpng-dev \
	libfreetype6-dev \
	libbz2-dev \
	autoconf \
	g++ \
	make \
	zip \
	unzip \
	ca-certificates \
	rsync

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install NODE.JS & NPM
RUN wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz
RUN tar -xf node-v${NODE_VERSION}-linux-x64.tar.xz
RUN mv node-v${NODE_VERSION}-linux-x64/bin/* /usr/local/bin/
RUN mv node-v${NODE_VERSION}-linux-x64/lib/node_modules/ /usr/local/lib/

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Composer
RUN composer global require "laravel/envoy"

# Set working directory
WORKDIR /var/www
