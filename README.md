# 🚀 Resume Website with S3, CloudFront, Route53 & WAF  

## 📌 Mission Statement  
Deploy a **personal resume website** as a static site using **AWS S3, CloudFront, Route53, and WAF**, with full **infrastructure automation via Terraform** and **CI/CD pipelines via GitHub Actions**.  

---

## 🏗️ Architecture  

Developer --> GitHub --> GitHub Actions (OIDC) --> AWS Infrastructure
│
▼
+------------------ CloudFront (CDN, HTTPS)
│
+------▼-------+
| AWS WAF | (Web security & filtering)
+--------------+
│
▼
S3 Bucket (Static Website Hosting)
│
▼
Route53 (DNS Routing)
│
▼
https://www.yourdomain.com

---

## ⚙️ AWS Services Used  

- **S3** → Static website hosting (resume HTML/CSS/JS).  
- **CloudFront** → CDN for global delivery, SSL termination, caching.  
- **Route53** → Custom domain & DNS management.  
- **WAF** → Protects against common web attacks (SQL injection, XSS, DDoS).  
- **Security Groups** → Restrict access if EC2/ALB backend is added in future.  
- **DynamoDB** → State locking for Terraform.  

---


## 📂 Project Structure  

resume-website-terraform/
├── .github/workflows/ # GitHub Actions CI/CD pipelines
│ └── deploy.yml
├── terraform/ # Terraform IaC (S3, CF, WAF, Route53)
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ └── backend.tf
├── website/ # Static resume files (HTML/CSS/JS)
│ ├── index.html
│ ├── error.html
│ └── styles.css
└── README.md # Project documentation

---

## 🔐 Security Design  

- **OIDC Authentication** → GitHub Actions assumes IAM Role (no hardcoded credentials).  
- **S3 Bucket** → Private (no public ACLs), accessible only via CloudFront OAI.  
- **CloudFront + ACM** → Enforces HTTPS for all requests.  
- **WAF** → Blocks SQLi, XSS, and common exploits.  
- **Terraform State** → Stored in S3 with DynamoDB for state locking.  
- **Security Groups** → Placeholder for EC2/ALB (not required for S3-only).  

---

## 🚀 Deployment Workflow (CI/CD with GitHub Actions)  

1. **Push to main branch** → triggers `deploy.yml`.  
2. **Terraform Steps**:  
   - Configure AWS OIDC authentication.  
   - Create/Update infra (S3, CloudFront, WAF, Route53).  
   - Store state in S3 with DynamoDB lock.  
3. **Website Deployment**:  
   - Sync files in `/website` → S3 bucket.  
   - CloudFront cache invalidation.  

---

## 🛠️ Setup Instructions  

### 1. Prerequisites  
- Domain registered in Route53 (or another registrar pointing to Route53).  
- AWS account with IAM OIDC role configured for GitHub Actions.  
- Terraform `>= 1.5.0`.  

### 2. Clone Repo  
```bash
git clone https://github.com/<your-username>/resume-website-terraform.git
cd resume-website-terraform

3. Initialize Terraform
terraform -chdir=terraform init
terraform -chdir=terraform plan
terraform -chdir=terraform apply


4. Push Website Content
Place your resume files inside /website, commit, and push → GitHub Actions will deploy automatically.
🌐 Accessing the Website
Website will be accessible at:
https://www.yourdomain.com (via Route53 + CloudFront).


👨🏾‍💻 Author
Kwabena Okyere Boakye – DevOps Enthusiast | AWS | Terraform | GitHub Actions