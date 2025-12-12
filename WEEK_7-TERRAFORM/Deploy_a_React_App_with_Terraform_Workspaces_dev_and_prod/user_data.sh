#!/bin/bash

# --- Environment Variables (Goal 1 Configuration) ---
FULL_NAME="Godwin Williams"
DEPLOY_DATE="07/10/2025"
REPO_URL="https://github.com/eyolegoo/my-react-app.git"
VM_USER="azureuser" # Matches var.vm_admin_username

# --- 1. System Update and Installation ---
echo "Starting system update and package installation (Node.js, npm, Nginx)..."
sudo apt update
sudo apt install -y nodejs npm
sudo apt install -y nginx

# Start and enable Nginx service
sudo systemctl start nginx
sudo systemctl enable nginx

# --- 2. Clone and Edit React App ---
echo "Cloning and configuring React application..."
cd /home/$VM_USER
git clone $REPO_URL

# Navigate to the source and edit App.js using sed
echo "Editing App.js to include name and date..."
cd my-react-app/src/
# Replace Full Name line
sudo sed -i "s|<h2>Deployed by: <strong>Your Full Name</strong></h2>|<h2>Deployed by: <strong>${FULL_NAME}</strong></h2>|g" App.js
# Replace Date line
sudo sed -i "s|<p>Date: <strong>DD/MM/YYYY</strong></p>|<p>Date: <strong>${DEPLOY_DATE}</strong></p>|g" App.js

# --- 3. Build the React App ---
echo "Building React application..."
cd /home/$VM_USER/my-react-app
npm install
npm run build

# --- 4. Deploy the Build Files to Nginx Web Directory ---
echo "Deploying build files to Nginx web root /var/www/html..."
sudo rm -rf /var/www/html/*
sudo cp -r build/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# --- 5. Configure Nginx for React (SPA Routing) ---
echo "Configuring Nginx for Single-Page Application (SPA) routing..."
NGINX_CONF='server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    error_page 404 /index.html;
}'
echo "$NGINX_CONF" | sudo tee /etc/nginx/sites-available/default > /dev/null

# --- 6. Restart Nginx to apply the changes ---
echo "Restarting Nginx service..."
sudo systemctl restart nginx
sudo systemctl status nginx | grep 'Active:'
echo "Deployment script finished."
