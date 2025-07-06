# Inventory Management System - DevOps CI/CD Pipeline

A complete DevOps CI/CD pipeline demonstration project featuring an Inventory Management System built with Spring Boot, integrated with Jenkins, Docker, Ansible, Graphite, and Grafana.

## 🏗️ Project Overview

This project demonstrates a complete DevOps pipeline for a Java Spring Boot application with the following components:

- **Application**: Inventory Management System (Spring Boot REST API)
- **Version Control**: Git
- **Build Tool**: Maven
- **CI/CD**: Jenkins Pipeline
- **Testing**: JUnit 5
- **Containerization**: Docker
- **Configuration Management**: Ansible
- **Monitoring**: Graphite + Grafana
- **Code Quality**: SonarQube
- **Security**: Vulnerability scanning

## 🚀 Features

### Application Features
- RESTful API for product management
- CRUD operations for inventory items
- Product categorization and search
- Low stock alerts
- Inventory statistics
- Health monitoring endpoints
- Swagger API documentation

### DevOps Features
- Automated CI/CD pipeline
- Multi-stage Docker builds
- Infrastructure as Code (Ansible)
- Real-time monitoring and alerting
- Code quality gates
- Security vulnerability scanning
- Automated testing and deployment

## 📋 Prerequisites

### Required Software
- **Java 11** or higher
- **Maven 3.8.4** or higher
- **Docker** and **Docker Compose**
- **Git**
- **Jenkins** (LTS version)
- **Ansible** (for configuration management)

### Optional Tools
- **Eclipse** or **IntelliJ IDEA** (for development)
- **Postman** (for API testing)
- **SonarQube** (for code quality analysis)

## 🛠️ Installation Guide

### 1. Install Java 11
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install openjdk-11-jdk

# Verify installation
java -version
```

### 2. Install Maven
```bash
# Download Maven
wget https://archive.apache.org/dist/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz

# Extract to /opt
sudo tar -xzf apache-maven-3.8.4-bin.tar.gz -C /opt

# Set environment variables
echo 'export MAVEN_HOME=/opt/apache-maven-3.8.4' >> ~/.bashrc
echo 'export PATH=$PATH:$MAVEN_HOME/bin' >> ~/.bashrc
source ~/.bashrc

# Verify installation
mvn -version
```

### 3. Install Docker
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version
```

### 4. Install Jenkins
```bash
# Add Jenkins repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt-get update
sudo apt-get install jenkins

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### 5. Install Ansible
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible

# Verify installation
ansible --version
```

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/inventory-management-system.git
cd inventory-management-system
```

### 2. Build the Application
```bash
mvn clean package
```

### 3. Run with Docker Compose
```bash
docker-compose up -d
```

### 4. Access the Application
- **Application**: http://localhost:8080
- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **H2 Database Console**: http://localhost:8080/h2-console
- **Grafana**: http://localhost:3000 (admin/admin123)
- **Graphite**: http://localhost:8081
- **Jenkins**: http://localhost:8082

## 📊 API Endpoints

### Product Management
- `GET /api/products` - Get all products
- `GET /api/products/{id}` - Get product by ID
- `POST /api/products` - Create new product
- `PUT /api/products/{id}` - Update product
- `DELETE /api/products/{id}` - Delete product

### Inventory Analytics
- `GET /api/products/category/{category}` - Get products by category
- `GET /api/products/low-stock/{threshold}` - Get low stock products
- `GET /api/products/out-of-stock` - Get out of stock products
- `GET /api/products/stats/in-stock-count` - Get in-stock count
- `GET /api/products/stats/total-inventory` - Get total inventory

### Health & Monitoring
- `GET /actuator/health` - Application health
- `GET /actuator/metrics` - Application metrics
- `GET /actuator/prometheus` - Prometheus metrics

## 🔧 Configuration

### Application Configuration
The application configuration is in `src/main/resources/application.yml`:

```yaml
server:
  port: 8080

spring:
  datasource:
    url: jdbc:h2:mem:inventorydb
    username: sa
    password: password

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

### Docker Configuration
The Docker setup is configured in `docker-compose.yml` with:
- Spring Boot application
- Graphite for metrics collection
- Grafana for monitoring dashboards
- Jenkins for CI/CD

### Ansible Configuration
Ansible playbooks are in the `ansible/` directory:
- `playbook.yml` - Main configuration playbook
- `inventory.ini` - Server inventory

## 🧪 Testing

### Run Unit Tests
```bash
mvn test
```

### Run Integration Tests
```bash
mvn verify
```

### Run with Coverage
```bash
mvn jacoco:report
```

### API Testing with curl
```bash
# Get all products
curl http://localhost:8080/api/products

# Create a product
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Product",
    "description": "Test Description",
    "price": 99.99,
    "quantity": 10,
    "category": "Electronics",
    "sku": "TEST-001"
  }'
```

## 📈 Monitoring

### Grafana Dashboards
The application includes pre-configured Grafana dashboards for:
- Application metrics
- System performance
- Business metrics
- Error rates

### Graphite Metrics
The application sends metrics to Graphite including:
- HTTP request rates
- Response times
- Error rates
- Business metrics (products created, updated, deleted)

### Health Checks
The application provides health check endpoints:
- `/actuator/health` - Overall application health
- `/actuator/health/db` - Database connectivity
- `/actuator/health/disk` - Disk space

## 🔄 CI/CD Pipeline

### Jenkins Pipeline Stages
1. **Checkout** - Clone source code
2. **Build** - Compile with Maven
3. **Unit Tests** - Run JUnit tests
4. **Code Coverage** - Generate JaCoCo report
5. **SonarQube Analysis** - Code quality check
6. **Security Scan** - Vulnerability scan
7. **Integration Tests** - End-to-end tests
8. **Build Docker Image** - Create container image
9. **Docker Security Scan** - Container vulnerability scan
10. **Push to Registry** - Store image
11. **Deploy to Staging** - Deploy to staging environment
12. **Staging Tests** - Validate staging deployment
13. **Deploy to Production** - Deploy to production
14. **Health Check** - Verify production deployment

### Pipeline Configuration
The pipeline is defined in `Jenkinsfile` and includes:
- Multi-stage deployment
- Automated testing
- Security scanning
- Monitoring integration
- Email notifications

## 🛡️ Security

### Security Features
- Input validation
- SQL injection prevention
- XSS protection
- CORS configuration
- Security headers
- Vulnerability scanning

### Security Scanning
- Maven dependency check
- Docker image scanning with Trivy
- SonarQube security analysis

## 📚 Documentation

### API Documentation
- Swagger UI: http://localhost:8080/swagger-ui.html
- OpenAPI specification: http://localhost:8080/api-docs

### Architecture Documentation
- System architecture diagrams
- Deployment diagrams
- Monitoring architecture

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the GitHub repository
- Contact the DevOps team
- Check the documentation

## 🔗 Links

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Docker Documentation](https://docs.docker.com/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Graphite Documentation](https://graphite.readthedocs.io/)

---

**Note**: This is a demonstration project for DevOps learning purposes. For production use, additional security, monitoring, and configuration should be implemented. #   d e v o p s  
 