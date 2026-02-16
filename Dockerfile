FROM wordpress:latest
COPY . /var/www/html/ 
RUN echo "Hello, this is my automated WordPress!" > /var/www/html/devops_check.txt