#cloud-config
package_update: true
package_upgrade: true
packages:
  - git
  - nginx
  - mysql-client
  - curl

write_files:
  - path: /home/azureuser/Epicbook/.env
    permissions: '0644'
    owner: azureuser:azureuser
    content: |
      DB_HOST=${db_host}
      DB_PORT=3306
      DB_USER=${db_username}
      DB_PASSWORD=${db_password}
      DB_NAME=bookstore
      DB_SSL=true
      PORT=3000

  - path: /etc/systemd/system/Epicbook.service
    permissions: '0644'
    owner: root:root
    content: |
      [Unit]
      Description=EpicBook Node.js App
      After=network.target

      [Service]
      WorkingDirectory=/home/azureuser/Epicbook
      ExecStart=/usr/bin/npm start
      Restart=always
      User=azureuser
      EnvironmentFile=/home/azureuser/Epicbook/.env
      StandardOutput=append:/var/log/epicbook.log
      StandardError=append:/var/log/epicbook-error.log

      [Install]
      WantedBy=multi-user.target

  - path: /etc/nginx/sites-available/default
    permissions: '0644'
    owner: root:root
    content: |
      server {
          listen 80;
          server_name _;

          location / {
              proxy_pass http://localhost:3000;
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
              proxy_set_header Host $host;
              proxy_cache_bypass $http_upgrade;
          }
      }

runcmd:
  # Log start
  - echo "===== Starting EpicBook VM setup =====" | tee /var/log/epicbook-install.log

  # Install Node.js + npm (LTS)
  - echo "Installing Node.js and npm..." | tee -a /var/log/epicbook-install.log
  - curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - >> /var/log/epicbook-install.log 2>&1
  - apt-get install -y nodejs >> /var/log/epicbook-install.log 2>&1
  - echo "Node version: $(node -v)" | tee -a /var/log/epicbook-install.log
  - echo "NPM version: $(npm -v)" | tee -a /var/log/epicbook-install.log

  # Clone or update the app
  - echo "Cloning app repository..." | tee -a /var/log/epicbook-install.log
  - git clone https://github.com/eyolegoo/theepicbook.git /home/azureuser/Epicbook || (cd /home/azureuser/Epicbook && git pull >> /var/log/epicbook-install.log)
  - chown -R azureuser:azureuser /home/azureuser/Epicbook

  # Install dependencies
  - echo "Installing npm dependencies..." | tee -a /var/log/epicbook-install.log
  - cd /home/azureuser/Epicbook && sudo -u azureuser npm install >> /var/log/epicbook-install.log 2>&1

  # Setup and start the app
  - echo "Setting up systemd service..." | tee -a /var/log/epicbook-install.log
  - systemctl daemon-reload
  - systemctl enable Epicbook
  - systemctl start Epicbook

  # Restart NGINX to pick up new config
  - echo "Restarting NGINX..." | tee -a /var/log/epicbook-install.log
  - systemctl restart nginx

  - echo "===== EpicBook setup complete! =====" | tee -a /var/log/epicbook-install.log