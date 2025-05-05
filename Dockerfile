# Use the official Python 3 base image
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Copy the repository files into the container
COPY . /app

# Install dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install cron
RUN apt-get update && apt-get install -y cron

# To support timeout 
# Install coreutils
RUN apt-get update && apt-get install -y coreutils

# Set the default command to run the script with the specified arguments
#CMD ["python", "ezshare_resmed.py", "--ssid", "ezshare", "--psk", "88888888", "--show_progress"]

RUN crontab -u root cron.txt

CMD ["/usr/sbin/cron", "-f"]
