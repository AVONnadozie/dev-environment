FROM php:8.0

# Install npm
# libzip-dev: for the PHP zip extension (used by Composer)
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt update && apt install -y git ssh apache2-utils nodejs python3-pip libzip-dev zip && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

# Install the `aws` CLI tool
RUN pip3 install --upgrade --user awscli && echo 'export PATH=/root/.local/bin:$PATH'>/root/.bashrc

# Install serverless
RUN npm install -g serverless

RUN docker-php-ext-install zip pdo_mysql

# Install docker client
ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 17.03.1-ce
ENV DOCKER_API_VERSION 1.27
RUN curl -fsSL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" \
  | tar -xzC /usr/local/bin --strip=1 docker/docker

RUN mkdir -p /var/task

# Register the Serverless and AWS bin directories
ENV PATH="/root/.serverless/bin:/root/.local/bin:${PATH}"

WORKDIR '/var/task'
