# 🐳 IaC DEV Container Docker Image

This repository contains a GitLab CI/CD configuration and a Dockerfile for building, testing, and securely deploying Docker images. The pipeline includes vulnerability scanning using [Trivy](https://github.com/aquasecurity/trivy) and supports both automated and manual image push and cleanup.

## 🦊 GitLab CI/CD Configuration

The `.gitlab-ci.yml` file defines the CI/CD pipeline with the following stages:

### 1. 📦 Build

- **kaniko-build**: Builds Docker images using Kaniko, which allows building Docker images without privileged access.

### 2. 🧪 Test

- **container_scanning**: Performs vulnerability scanning on the Docker image built in the previous stage using GitLab Container Scanning. It checks for security vulnerabilities and generates a scanning report.

- **check_container_scanning**: Checks the results of container scanning. It counts the number of vulnerabilities and determines whether the job should fail based on the severity threshold and ALLOW_FAILURE variable.

- **package_check**: Verifies if the package is installed and accessible by checking its version.

### 3. 🚚 Release

- **release:**: In GitLab, a release enables you to create a snapshot of your project for your users, including installation packages and release notes. This release stage is intended to automate the process of creating releases based on Git tags, leveraging GitLab's release-cli tool. It ensures that releases are created only after successful completion of container scanning, and only for pipeline runs triggered by tag events.

### 4. 🧹 Clean Up

- **delete_remote_tag**: Deletes the Git tag on the remote repository if the build fails.

- **delete_repository_tag**: Deletes the Docker image tag from the GitLab Container Registry if the build fails.

## 📄 Dockerfile

The `Dockerfile` in this repository is designed to create a Docker image based on IaC CICD image. It includes various DevOps and infrastructure as code (IAC) tools commonly used in CI/CD workflows. The tools installed in this Docker image include:

base-image:
- python3-pip
- wget
- unzip
- diffutils
- tar
- gzip
- git
- pre-commit
- yamllint
- yamlfmt
- ansible
- ansible-linit

iac-devcontainer:
- nano
- vim
- bash-completion

You can customise the versions of these tools by providing build arguments when building the Docker image.

## 📚 Getting Started

1. Log in to GitLab: Sign in to your GitLab account.

### Creating a Project

1. **Select** the **container group** where you want to **create** the **project**.
1. Once inside the container group, click on the **New project** button.
1. Fill in the necessary details for the new project, including the project name ("**iac-devcontainer**") and project path.
1. **Set Visibility Level:** In the group creation form, locate the **Visibility Level** select "**Internal**." This setting ensures that the group and its contents are visible to all logged-in users.
1. Click on the **Create project** button to finalise the creation of the "iac-cicd" project.

### Generating a Project Access Token
Generating a Project Access Token will be used to remove a Git tag if a build fails and to delete a registry repository tag.

**Project Access Token:**

1. Navigate to Your Project
1. Select Settings > Access Tokens.
1. Create a New Token:
	- Token name: PAC_IAC_DEVCONTAINER_1
	- CI/CD Variable Name: PAC_IAC_DEVCONTAINER_1
	- Role: Maintainer
	- Scopes: api, read_registry, write_registry
	- Notes: Manage project-level CI/CD variables, require maintainer and api scope.

### Defining a Project Variable

Defining a Project Variable is essential for setting up the Project Access Token used for authentication within the CI/CD jobs.

1. Go to your project’s Settings > CI/CD and expand the Variables section.
1. Select Add variable and fill in the details:

- **Type:** Variable (default)
- **Environment scope:** All (default)
- **Flag:**
	- **Protect variable:** Optional. If selected, the variable is only available in pipelines that run on protected branches or protected tags.
	- **Mask variable** Selected
	- **Expand variable reference:** Selected
- **Description (optional):** Token name: PAC_IAC_DEVCONTAINER_1
- **Key:** PAC_IAC_DEVCONTAINER_1
- **Value:** The token was generated in previous steps.

## 📚 How to Deploy

To clone a repository from a public GitLab repository and push it to a private GitLab repository, you can follow these steps:

1. Clone the public repository:

    ```
    git clone <public_repository_url>
    ```

1. Navigate into the cloned repository:

    ```
    cd <repository_name>
    ```

1. Add the private repository as a new remote:

    ```
    git remote set-url origin <private_repository_url>
    ```

1. Push the cloned repository to the private repository:

    ```
    git push
    ```

1. Create the tag in the GitLab portal to the GitLab repository to trigger the CI/CD pipeline. The pipeline will build, test, and deploy your Docker image while ensuring security through vulnerability scanning.

## How to run docker-compose

Run docker-compose --env-file .env.user up -d to start the DevContainer with settings from the .env.user file, providing an isolated and consistent development environment.
```
docker-compose --env-file .env.user up -d
```

To stop and remove the DevContainer, use 
```
docker-compose --env-file .env.user downå
```

which will halt and clean up the development environment.

Access the running DevContainer with 
```
docker exec -it <username>_devcontainer /bin/bash
```
to open an interactive shell for development and debugging.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🇬🇧🇭🇰 Author Information

* Author: Jody WAN
* Linkedin: https://www.linkedin.com/in/jodywan/
* Website: https://www.jodywan.com