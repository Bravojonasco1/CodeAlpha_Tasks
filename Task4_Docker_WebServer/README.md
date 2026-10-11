# CodeAlpha Task 4 — Web Server Using Docker

![Docker](https://img.shields.io/badge/Docker-Containerization-blue)
![Nginx](https://img.shields.io/badge/Nginx-Web%20Server-green)
![AWS](https://img.shields.io/badge/AWS-EC2-orange)
![Linux](https://img.shields.io/badge/Linux-Amazon%20Linux%202023-lightgrey)

## 📌 Project Overview

This project was completed as **Task 4 of the CodeAlpha DevOps Internship**.

The objective was to learn the fundamentals of Docker containerization by deploying a web server inside a Docker container, managing the container lifecycle, monitoring container health, troubleshooting issues, and applying container-based deployment best practices.

For this project, I deployed an **Nginx web server inside a Docker container** running on an **AWS EC2 instance**. The container serves a custom HTML webpage created specifically for the CodeAlpha internship task.

The project demonstrates a complete containerized web-server workflow:

```text
Application Source
       ↓
Dockerfile
       ↓
Docker Image
       ↓
Docker Container
       ↓
Nginx Web Server
       ↓
AWS EC2 Port 80
       ↓
Web Browser
```

---

# 🎯 Objectives

The project was designed to demonstrate the following:

* Learn Docker containerization basics
* Create a Docker image using a Dockerfile
* Deploy an Nginx web server inside a Docker container
* Understand Docker port mapping
* Manage the Docker container lifecycle
* Monitor container health
* Inspect container configuration
* View and analyze container logs
* Troubleshoot a real web-server issue
* Rebuild and redeploy a Docker image
* Apply container deployment best practices

---

# 🛠️ Technologies Used

| Technology        | Purpose                                     |
| ----------------- | ------------------------------------------- |
| AWS EC2           | Cloud server hosting the Docker environment |
| Amazon Linux 2023 | Operating system                            |
| Docker            | Containerization platform                   |
| Nginx             | Web server                                  |
| HTML5             | Webpage                                     |
| SVG               | Favicon                                     |
| Bash              | Server and Docker commands                  |
| Git               | Version control                             |
| GitHub            | Project repository                          |

---

# 🏗️ Architecture

```text
                    Internet
                       |
                       | HTTP :80
                       ↓
              AWS EC2 Instance
             Amazon Linux 2023
                       |
                       | Docker
                       ↓
          ┌─────────────────────────┐
          │   Docker Container      │
          │                         │
          │        Nginx            │
          │          │              │
          │          ↓              │
          │     index.html          │
          │          +              │
          │     favicon.svg         │
          └─────────────────────────┘
                       |
                       ↓
                HTTP Response
                       |
                       ↓
                  Web Browser
```

---

# 📁 Project Structure

```text
CodeAlpha_Task4_Docker_WebServer/
│
├── .dockerignore
├── Dockerfile
├── README.md
├── favicon.svg
└── index.html
```

### File Description

| File            | Description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| `Dockerfile`    | Contains instructions for building the Nginx Docker image                  |
| `index.html`    | Custom webpage served by Nginx                                             |
| `favicon.svg`   | Browser favicon                                                            |
| `.dockerignore` | Prevents unnecessary files from being included in the Docker build context |
| `README.md`     | Project documentation                                                      |

---

# ☁️ 1. AWS EC2 Environment

The Docker web server was deployed on an AWS EC2 instance running:

```text
Amazon Linux 2023
```

The EC2 instance provided the Linux environment required to install and run Docker.

The Docker service was started with:

```bash
sudo systemctl start docker
```

Docker was configured to start automatically when the server boots:

```bash
sudo systemctl enable docker
```

Docker service status was verified with:

```bash
sudo systemctl status docker
```

The Docker service was confirmed to be:

```text
active (running)
```

---

# 🐳 2. Docker Installation Verification

Docker installation was verified using:

```bash
docker --version
```

The Docker installation was also tested using the official `hello-world` image:

```bash
docker run hello-world
```

The successful output confirmed that:

* Docker client was working
* Docker daemon was working
* Docker could pull images from Docker Hub
* Docker could create containers
* Docker could execute containers successfully

---

# 👤 3. Docker User Configuration

The EC2 user was added to the Docker group:

```bash
sudo usermod -aG docker ec2-user
```

After reconnecting to the EC2 instance, group membership was checked:

```bash
groups
```

The `docker` group was present, allowing Docker commands to be executed without repeatedly using `sudo`.

---

# 📂 4. Application Directory

The project directory was created with:

```bash
mkdir -p ~/CodeAlpha_Task4_Docker_WebServer
cd ~/CodeAlpha_Task4_Docker_WebServer
```

The custom webpage was created as:

```text
index.html
```

The webpage contains:

* CodeAlpha Task 4 title
* Docker web-server description
* Nginx identification
* Docker running status
* Developer information

---

# 🌐 5. HTML Webpage

The webpage is served by Nginx from its default web directory:

```text
/usr/share/nginx/html/
```

The main webpage is:

```text
index.html
```

The webpage displays:

> CodeAlpha Task 4
> Web Server Using Docker

It also identifies Nginx as the web server running inside the Docker container.

---

# 🐋 6. Dockerfile

The project uses the following Dockerfile:

```dockerfile
FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html
COPY favicon.svg /usr/share/nginx/html/favicon.svg

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1
```

## Dockerfile Explanation

### `FROM`

```dockerfile
FROM nginx:alpine
```

Uses the lightweight Alpine-based Nginx image as the base image.

### `COPY`

```dockerfile
COPY index.html /usr/share/nginx/html/index.html
```

Copies the custom webpage into the default Nginx web directory.

```dockerfile
COPY favicon.svg /usr/share/nginx/html/favicon.svg
```

Copies the favicon into the Nginx web directory.

### `EXPOSE`

```dockerfile
EXPOSE 80
```

Documents that the Nginx server listens on port 80 inside the container.

### `HEALTHCHECK`

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1
```

Configures Docker to periodically check whether the Nginx web server is responding.

---

# 🚫 7. `.dockerignore`

The project uses a `.dockerignore` file containing:

```text
.git
.gitignore
README.md
screenshots/
*.log
```

The purpose is to prevent unnecessary files from being included in the Docker build context.

This helps keep the build context clean and avoids sending files that are not required by the application.

---

# 🏗️ 8. Build the Docker Image

The Docker image was built using:

```bash
docker build -t codealpha-task4-webserver .
```

The image was then verified using:

```bash
docker images
```

The resulting image was:

```text
codealpha-task4-webserver:latest
```

The image was also inspected using:

```bash
docker image inspect codealpha-task4-webserver --format '{{.RepoTags}}'
```

Result:

```text
[codealpha-task4-webserver:latest]
```

---

# 🚀 9. Run the Docker Container

The Nginx container was created and started using:

```bash
docker run -d \
  --name codealpha-webserver \
  -p 80:80 \
  codealpha-task4-webserver
```

## Command Explanation

### Detached mode

```text
-d
```

Runs the container in the background.

### Container name

```text
--name codealpha-webserver
```

Assigns a meaningful name to the container.

### Port mapping

```text
-p 80:80
```

Maps:

```text
EC2 Host Port 80
       ↓
Docker Container Port 80
```

This allows HTTP requests received on the EC2 instance's port 80 to reach Nginx inside the container.

---

# 🔍 10. Verify the Running Container

The container was verified using:

```bash
docker ps
```

The container reported a status similar to:

```text
Up ... (healthy)
```

The port mapping was displayed as:

```text
0.0.0.0:80->80/tcp
```

The container state was also checked using:

```bash
docker inspect codealpha-webserver --format '{{.State.Status}}'
```

Expected result:

```text
running
```

---

# ❤️ 11. Container Health Monitoring

The project includes a Docker health check.

Health status was checked with:

```bash
docker inspect codealpha-webserver --format '{{.State.Health.Status}}'
```

The container reported:

```text
healthy
```

The health status and failing streak were also checked with:

```bash
docker inspect codealpha-webserver \
  --format 'Health: {{.State.Health.Status}} | Failing Streak: {{.State.Health.FailingStreak}}'
```

Final result:

```text
Health: healthy | Failing Streak: 0
```

This confirms that the configured Nginx health check was passing successfully.

---

# 📊 12. Container Resource Monitoring

Docker's resource monitoring command was used:

```bash
docker stats --no-stream codealpha-webserver
```

This provides information about:

* CPU usage
* Memory usage
* Network I/O
* Block I/O
* Process count

This demonstrates basic container resource monitoring.

---

# 📝 13. Container Logs

Nginx logs were viewed using:

```bash
docker logs codealpha-webserver
```

The logs showed successful health-check requests:

```text
GET / HTTP/1.1" 200
```

The browser also generated successful requests.

An HTTP `200` response indicates that the web server successfully served the requested resource.

---

# 🌍 14. Browser Verification

The deployed application was accessed using the public IP address of the EC2 instance:

```text
http://<EC2-PUBLIC-IP>
```

The custom CodeAlpha webpage loaded successfully in the browser.

The request flow was:

```text
Browser
   ↓
EC2 Public IP
   ↓
Port 80
   ↓
Docker Port Mapping
   ↓
Nginx Container
   ↓
index.html
   ↓
HTTP 200
```

This confirmed that the containerized Nginx web server was publicly accessible.

---

# 🔧 15. Troubleshooting

During the initial browser test, the main webpage worked successfully, but the Nginx logs showed a favicon error:

```text
GET /favicon.ico HTTP/1.1" 404
```

The HTTP 404 response occurred because the browser requested a favicon that was not present in the Nginx web directory.

The main webpage itself continued to return HTTP 200.

## Troubleshooting Solution

A `favicon.svg` file was created and added to the project.

The HTML page was updated with:

```html
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
```

The Dockerfile was updated to copy the favicon:

```dockerfile
COPY favicon.svg /usr/share/nginx/html/favicon.svg
```

The Docker image was rebuilt:

```bash
docker build -t codealpha-task4-webserver .
```

The previous container was stopped:

```bash
docker stop codealpha-webserver
```

The previous container was removed:

```bash
docker rm codealpha-webserver
```

A new container was deployed:

```bash
docker run -d \
  --name codealpha-webserver \
  -p 80:80 \
  codealpha-task4-webserver
```

The fix was then verified through the Nginx logs.

The favicon request successfully returned:

```text
GET /favicon.svg HTTP/1.1" 200
```

This demonstrated a complete troubleshooting cycle:

```text
Problem
   ↓
Log Analysis
   ↓
Identify Cause
   ↓
Modify Source
   ↓
Rebuild Image
   ↓
Redeploy Container
   ↓
Verify Fix
```

---

# 🔄 16. Container Lifecycle Management

The project demonstrated the Docker container lifecycle.

## Stop

```bash
docker stop codealpha-webserver
```

Stops the running container.

## List Running Containers

```bash
docker ps
```

Displays currently running containers.

## List All Containers

```bash
docker ps -a
```

Displays both running and stopped containers.

## Start

```bash
docker start codealpha-webserver
```

Starts an existing stopped container.

## Restart

```bash
docker restart codealpha-webserver
```

Restarts the existing container.

After restarting, the container temporarily entered the health-check startup state and subsequently returned to:

```text
healthy
```

This demonstrated the normal container lifecycle and health-check behavior.

---

# 🔎 17. Container Inspection

The Docker `inspect` command was used to examine the running container.

### Image

```bash
docker inspect codealpha-webserver \
  --format 'Image: {{.Config.Image}}'
```

Result:

```text
Image: codealpha-task4-webserver
```

### Port Configuration

```bash
docker inspect codealpha-webserver \
  --format 'Ports: {{json .NetworkSettings.Ports}}'
```

This confirmed:

```text
Host Port 80 → Container Port 80
```

### Start Time

```bash
docker inspect codealpha-webserver \
  --format 'Started: {{.State.StartedAt}}'
```

This displays when the current container instance started.

---

# 🧱 18. Container-Based Deployment Best Practices

Several Docker best practices were demonstrated.

## Lightweight Base Image

The project uses:

```dockerfile
FROM nginx:alpine
```

The Alpine-based image provides a lightweight base for the Nginx web server.

## Health Monitoring

A Docker `HEALTHCHECK` was included in the Dockerfile to continuously verify application availability.

## `.dockerignore`

Unnecessary files are excluded from the Docker build context.

## Named Containers

The container was given the descriptive name:

```text
codealpha-webserver
```

This makes operational commands easier to understand.

## Image-Based Deployment

When the favicon issue was discovered, the running container was not manually modified.

Instead, the deployment followed:

```text
Source Code
    ↓
Dockerfile Update
    ↓
New Image
    ↓
New Container
```

This demonstrates a reproducible image-based deployment workflow.

## Separation of Application and Infrastructure

The HTML application is maintained as source code, while the Dockerfile defines how the application is packaged and deployed.

---

# 🧪 19. Final Verification

The final deployment was verified using:

```bash
docker ps
```

The container reported:

```text
Up ... (healthy)
```

Health was verified using:

```bash
docker inspect codealpha-webserver \
  --format 'Health: {{.State.Health.Status}} | Failing Streak: {{.State.Health.FailingStreak}}'
```

Final result:

```text
Health: healthy | Failing Streak: 0
```

The application was successfully accessed through the EC2 public IP address.

Nginx logs confirmed successful requests for both:

```text
/
```

and:

```text
/favicon.svg
```

The final deployment therefore consisted of:

```text
AWS EC2
   ↓
Docker
   ↓
Nginx Container
   ↓
Custom HTML Application
   ↓
HTTP Port 80
   ↓
Browser
```

---

# 🎥 Evidence and Demonstration

The implementation was documented through terminal screenshots, browser verification and an explanatory video.

Recommended evidence includes:

1. Docker installation and `hello-world` verification
2. Project structure
3. Dockerfile
4. Docker image creation
5. Running and healthy container
6. Browser showing the deployed website
7. Nginx logs
8. Troubleshooting and favicon fix
9. Updated healthy container
10. Container lifecycle operations
11. Container health monitoring
12. Resource monitoring
13. Final project structure

---

# 🎯 Task Requirements Completed

| Requirement                                                   | Status      |
| ------------------------------------------------------------- | ----------- |
| Learn Docker containerization basics                          | ✅ Completed |
| Deploy and manage a web server inside Docker                  | ✅ Completed |
| Understand container lifecycle and commands                   | ✅ Completed |
| Monitor container health                                      | ✅ Completed |
| Troubleshoot container/web-server issues                      | ✅ Completed |
| Explore container-based application deployment best practices | ✅ Completed |

---

# 📚 Key Docker Commands Used

```bash
# Check Docker version
docker --version

# Test Docker installation
docker run hello-world

# Build image
docker build -t codealpha-task4-webserver .

# List images
docker images

# Run container
docker run -d --name codealpha-webserver -p 80:80 codealpha-task4-webserver

# View running containers
docker ps

# View all containers
docker ps -a

# View container logs
docker logs codealpha-webserver

# Follow container logs
docker logs -f codealpha-webserver

# Stop container
docker stop codealpha-webserver

# Start container
docker start codealpha-webserver

# Restart container
docker restart codealpha-webserver

# Remove container
docker rm codealpha-webserver

# Inspect container
docker inspect codealpha-webserver

# Check container health
docker inspect codealpha-webserver --format '{{.State.Health.Status}}'

# Monitor container resources
docker stats --no-stream codealpha-webserver
```

---

# 👨‍💻 Author

**Eziorobo John Ezeakpono**

DevOps Engineer

**CodeAlpha DevOps Internship — Task 4**

Project: **Web Server Using Docker**

---

# 🏁 Conclusion

This project provided practical experience with Docker containerization by deploying an Nginx web server on AWS EC2.

The implementation covered the complete container workflow from creating application source files and a Dockerfile, building an image, running the container, exposing the web server through port 80, monitoring its health, inspecting logs, managing its lifecycle and troubleshooting a real HTTP 404 issue.

The final result is a healthy Nginx Docker container serving a custom CodeAlpha webpage through an AWS EC2 instance.

