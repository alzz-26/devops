
#!/bin/bash

# DevOps CI/CD Pipeline Project Setup Script
# Inventory Management System

set -e

echo "🚀 Starting DevOps CI/CD Pipeline Project Setup..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Java 11
install_java() {
    print_status "Installing Java 11..."
    
    if command_exists java; then
        JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
        if [ "$JAVA_VERSION" -eq 11 ]; then
            print_success "Java 11 is already installed"
            return 0
        fi
    fi
    
    sudo apt update
    sudo apt install -y openjdk-11-jdk
    
    if command_exists java; then
        print_success "Java 11 installed successfully"
        java -version
    else
        print_error "Failed to install Java 11"
        exit 1
    fi
}

# Function to install Maven
install_maven() {
    print_status "Installing Maven 3.8.4..."
    
    if command_exists mvn; then
        print_success "Maven is already installed"
        mvn -version
        return 0
    fi
    
    # Download Maven
    wget -q https://archive.apache.org/dist/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz
    
    # Extract to /opt
    sudo tar -xzf apache-maven-3.8.4-bin.tar.gz -C /opt
    
    # Set environment variables
    echo 'export MAVEN_HOME=/opt/apache-maven-3.8.4' >> ~/.bashrc
    echo 'export PATH=$PATH:$MAVEN_HOME/bin' >> ~/.bashrc
    
    # Clean up
    rm apache-maven-3.8.4-bin.tar.gz
    
    # Source bashrc
    source ~/.bashrc
    
    if command_exists mvn; then
        print_success "Maven 3.8.4 installed successfully"
        mvn -version
    else
        print_error "Failed to install Maven"
        exit 1
    fi
}

# Function to install Docker
install_docker() {
    print_status "Installing Docker..."
    
    if command_exists docker; then
        print_success "Docker is already installed"
        docker --version
        return 0
    fi
    
    # Install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    
    # Add user to docker group
    sudo usermod -aG docker $USER
    
    # Install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    
    # Clean up
    rm get-docker.sh
    
    if command_exists docker; then
        print_success "Docker installed successfully"
        docker --version
        docker-compose --version
    else
        print_error "Failed to install Docker"
        exit 1
    fi
}

# Function to install Jenkins
install_jenkins() {
    print_status "Installing Jenkins..."
    
    if systemctl is-active --quiet jenkins; then
        print_success "Jenkins is already installed and running"
        return 0
    fi
    
    # Add Jenkins repository
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    
    # Install Jenkins
    sudo apt-get update
    sudo apt-get install -y jenkins
    
    # Start and enable Jenkins
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    
    if systemctl is-active --quiet jenkins; then
        print_success "Jenkins installed and started successfully"
        print_status "Initial admin password:"
        sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    else
        print_error "Failed to install or start Jenkins"
        exit 1
    fi
}

# Function to install Ansible
install_ansible() {
    print_status "Installing Ansible..."
    
    if command_exists ansible; then
        print_success "Ansible is already installed"
        ansible --version
        return 0
    fi
    
    sudo apt update
    sudo apt install -y software-properties-common
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
    
    if command_exists ansible; then
        print_success "Ansible installed successfully"
        ansible --version
    else
        print_error "Failed to install Ansible"
        exit 1
    fi
}

# Function to install Graphite
install_graphite() {
    print_status "Installing Graphite..."
    
    # Install Graphite dependencies
    sudo apt update
    sudo apt install -y python3-pip python3-dev libffi-dev libssl-dev
    
    # Install Graphite using pip
    sudo pip3 install graphite-web
    sudo pip3 install carbon
    sudo pip3 install whisper
    
    # Create Graphite directories
    sudo mkdir -p /opt/graphite/storage/log
    sudo mkdir -p /opt/graphite/storage/whisper
    sudo mkdir -p /opt/graphite/webapp/graphite
    
    # Set permissions
    sudo chown -R $USER:$USER /opt/graphite
    
    print_success "Graphite installed successfully"
}

# Function to install Grafana
install_grafana() {
    print_status "Installing Grafana..."
    
    if command_exists grafana-server; then
        print_success "Grafana is already installed"
        return 0
    fi
    
    # Add Grafana repository
    wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
    echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
    
    # Install Grafana
    sudo apt update
    sudo apt install -y grafana
    
    # Start and enable Grafana
    sudo systemctl start grafana-server
    sudo systemctl enable grafana-server
    
    if systemctl is-active --quiet grafana-server; then
        print_success "Grafana installed and started successfully"
        print_status "Grafana is running on http://localhost:3000"
        print_status "Default credentials: admin/admin"
    else
        print_error "Failed to install or start Grafana"
        exit 1
    fi
}

# Function to setup project
setup_project() {
    print_status "Setting up project structure..."
    
    # Create project directory if it doesn't exist
    if [ ! -d "inventory-management-system" ]; then
        mkdir -p inventory-management-system
    fi
    
    cd inventory-management-system
    
    # Create directory structure
    mkdir -p src/main/java/com/devops/inventory/{controller,service,repository,model}
    mkdir -p src/main/resources
    mkdir -p src/test/java/com/devops/inventory
    mkdir -p ansible
    mkdir -p grafana/provisioning/{datasources,dashboards}
    
    print_success "Project structure created"
}

# Function to build application
build_application() {
    print_status "Building application..."
    
    if [ -f "pom.xml" ]; then
        mvn clean package -DskipTests
        print_success "Application built successfully"
    else
        print_warning "pom.xml not found. Please ensure you're in the correct directory."
    fi
}

# Function to start services
start_services() {
    print_status "Starting services with Docker Compose..."
    
    if [ -f "docker-compose.yml" ]; then
        docker-compose up -d
        print_success "Services started successfully"
        
        echo ""
        print_status "Service URLs:"
        echo "  Application: http://localhost:8080"
        echo "  Swagger UI: http://localhost:8080/swagger-ui.html"
        echo "  Grafana: http://localhost:3000 (admin/admin123)"
        echo "  Graphite: http://localhost:8081"
        echo "  Jenkins: http://localhost:8082"
        echo ""
        
        print_status "Waiting for services to be ready..."
        sleep 30
        
        # Check if services are running
        if curl -f http://localhost:8080/actuator/health >/dev/null 2>&1; then
            print_success "Application is running and healthy"
        else
            print_warning "Application health check failed. Check logs with: docker-compose logs"
        fi
        
    else
        print_warning "docker-compose.yml not found. Please ensure you're in the correct directory."
    fi
}

# Function to configure Grafana
configure_grafana() {
    print_status "Configuring Grafana..."
    
    # Wait for Grafana to be ready
    sleep 10
    
    # Create Grafana data source configuration
    mkdir -p grafana/provisioning/datasources
    cat > grafana/provisioning/datasources/graphite.yml << EOF
apiVersion: 1

datasources:
  - name: Graphite
    type: graphite
    access: proxy
    url: http://localhost:8081
    isDefault: true
EOF
    
    print_success "Grafana configured with Graphite data source"
}

# Function to show next steps
show_next_steps() {
    echo ""
    echo "🎉 Setup Complete!"
    echo "=================="
    echo ""
    echo "Next steps:"
    echo "1. Access Jenkins at http://localhost:8082"
    echo "2. Get initial password: sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
    echo "3. Install suggested plugins"
    echo "4. Create admin user"
    echo "5. Create a new pipeline job pointing to your Git repository"
    echo "6. Configure Jenkins tools (JDK, Maven)"
    echo "7. Run the pipeline"
    echo ""
    echo "Monitoring Setup:"
    echo "1. Access Grafana at http://localhost:3000 (admin/admin)"
    echo "2. Access Graphite at http://localhost:8081"
    echo "3. Configure dashboards in Grafana"
    echo ""
    echo "For detailed instructions, see the README.md file"
    echo ""
}

# Main execution
main() {
    echo "Checking system requirements..."
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        print_error "Please don't run this script as root"
        exit 1
    fi
    
    # Check if running on Ubuntu/Debian
    if ! command_exists apt; then
        print_error "This script is designed for Ubuntu/Debian systems"
        exit 1
    fi
    
    # Install prerequisites
    install_java
    install_maven
    install_docker
    install_jenkins
    install_ansible
    install_graphite
    install_grafana
    
    # Setup project
    setup_project
    
    # Configure Grafana
    configure_grafana
    
    # Build application (if pom.xml exists)
    if [ -f "pom.xml" ]; then
        build_application
        start_services
    fi
    
    show_next_steps
}

# Run main function
main "$@"