# 🚀 Terraform + Docker: Automated Deployment

## 📌 Overview
This project automates the deployment of a Dockerized application using **Terraform** and **AWS EC2**. Additionally, it manages the repository files using **GitHub Provider for Terraform**.

## 🏗️ Features
- **Terraform** provisions an EC2 instance with security groups.
- **Docker** deploys the application using a `Dockerfile` and `docker-compose.yml`.
- **GitHub Integration** ensures repository files are managed via Terraform.

## 📂 Project Structure
```
📁 terraform-docker-deployment
│── main.tf              # Terraform configuration for AWS & GitHub
│── variables.tf         # Terraform variables
│── userdata.sh          # Bootstrapping script for EC2
│── bookstore-api.py     # Sample Python API
│── Dockerfile           # Docker container setup
│── compose.yml          # Docker Compose configuration
│── requirements.txt     # Python dependencies
└── README.md            # Project documentation
```

## 🚀 Deployment Steps
### 1️⃣ Prerequisites
- AWS credentials configured
- GitHub personal access token (PAT) available
- Export the required environmental variables
- ```terraform apply --auto-approve```

### 2️⃣ Access the Application
After successful deployment, find the EC2 instance’s public IP:
```sh
echo "http://$(terraform output -raw website-url)"
```
Open the URL in your browser to access the application.

### 3️⃣ Destroy AWS Resources (Excluding GitHub Repository & Files)
```sh
terraform destroy -target=aws_instance.tf-docker-instance -target=aws_security_group.tf-docker-sg
```

## 📌 Notes
- The GitHub repository **will not be deleted** during `terraform destroy` due to lifecycle rules.
- Modify `userdata.sh` to include custom initialization scripts.

## 📜 License
This project is open-source and available under the [MIT License](LICENSE).

---

🔥 Happy Automating! 🚀

