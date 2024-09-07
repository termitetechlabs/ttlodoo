# Use an official Python runtime as a parent image
FROM python:3

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    postgresql \
    postgresql-client \
    sudo \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install rtlcss globally
RUN npm install -g rtlcss

# Set up PostgreSQL
RUN sudo -u postgres createuser -d -R -S root
RUN createdb root

# Clone Odoo repository
WORKDIR /opt
RUN git clone https://github.com/odoo/odoo.git

# Install Odoo dependencies
WORKDIR /opt/odoo
RUN ./setup/debinstall.sh

# Set the working directory
WORKDIR /opt/odoo

# Expose Odoo port
EXPOSE 8069

# Command to run Odoo
CMD ["python3", "odoo-bin", "--addons-path=addons", "-d", "mydb"]
