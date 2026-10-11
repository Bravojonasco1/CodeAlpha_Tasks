# CodeAlpha Task 3 — Java Application Using Gradle & Jenkins CI/CD

## 📌 Project Overview

This project demonstrates the automation of a Java application build and deployment process using **Gradle** and **Jenkins**.

The objective of this task was to understand how DevOps practices can be applied to Java development by automating:

* Java application builds
* Dependency management
* Automated testing
* JAR packaging
* Artifact archiving
* Continuous Integration (CI)
* Continuous Delivery (CD)
* Application deployment

The project uses **Gradle 8.14.4**, **Java 21**, **GitHub**, and **Jenkins** running on an AWS EC2 instance.

---

## 🏗️ Architecture

```text
                    GitHub
                       │
                       │ Source Code
                       ▼
                 ┌───────────┐
                 │  Jenkins  │
                 │  EC2      │
                 └─────┬─────┘
                       │
                       ▼
                Checkout Source
                       │
                       ▼
              Verify Java & Gradle
                       │
                       ▼
                 Gradle Test
                       │
                       ▼
                Gradle Build
                       │
                       ▼
                  JAR File
                       │
                       ▼
              Archive Artifact
                       │
                       ▼
                   Deploy
                       │
                       ▼
             /opt/codealpha/
                       │
                       ▼
                  java -jar
                       │
                       ▼
       Hello from CodeAlpha Gradle CI/CD!
```

---

## 🛠️ Technologies Used

| Technology        | Purpose                                    |
| ----------------- | ------------------------------------------ |
| Java 21           | Java development and application runtime   |
| Gradle 8.14.4     | Build automation and dependency management |
| Jenkins           | CI/CD automation                           |
| Git               | Source-code version control                |
| GitHub            | Remote source-code repository              |
| AWS EC2           | Jenkins server and deployment environment  |
| Amazon Linux 2023 | Server operating system                    |

---

## 📁 Project Structure

```text
CodeAlpha_Gradle_Java/
│
├── .gitignore
├── Jenkinsfile
├── build.gradle
├── settings.gradle
├── gradlew
├── gradlew.bat
│
├── gradle/
│   └── wrapper/
│
└── src/
    ├── main/
    │   └── java/
    │       └── com/
    │           └── codealpha/
    │               └── App.java
    │
    └── test/
        └── java/
            └── com/
                └── codealpha/
                    └── AppTest.java
```

---

# ☕ Java Application

The application is a simple Java program used to demonstrate the automated build and deployment process.

The main class is:

```text
com.codealpha.App
```

The application prints:

```text
Hello from CodeAlpha Gradle CI/CD!
```

It also contains a method used by the automated test:

```java
public static String getMessage() {
    return "CodeAlpha Gradle CI/CD is working!";
}
```

---

# 🔧 Gradle Configuration

The project uses the Gradle Java and Application plugins.

```gradle
plugins {
    id 'java'
    id 'application'
}
```

The project uses Maven Central for dependencies:

```gradle
repositories {
    mavenCentral()
}
```

JUnit 5 is used for testing:

```gradle
dependencies {
    testImplementation platform('org.junit:junit-bom:5.11.4')
    testImplementation 'org.junit.jupiter:junit-jupiter'
}
```

The application's entry point is defined as:

```gradle
application {
    mainClass = 'com.codealpha.App'
}
```

The JAR manifest also defines the main class:

```gradle
jar {
    manifest {
        attributes(
            'Main-Class': 'com.codealpha.App'
        )
    }
}
```

This allows the generated application to be executed using:

```bash
java -jar CodeAlpha_Gradle_Java-1.0.0.jar
```

---

# 🔄 Jenkins CI/CD Pipeline

The Jenkins pipeline is defined in:

```text
Jenkinsfile
```

The pipeline performs the following stages:

```text
Checkout
   ↓
Verify Java & Gradle
   ↓
Test
   ↓
Build
   ↓
Archive JAR
   ↓
Deploy
```

## 1. Checkout

Jenkins retrieves the source code from GitHub.

Repository:

```text
https://github.com/Bravojonasco1/CodeAlpha_Gradle_Java.git
```

---

## 2. Verify Java & Gradle

The pipeline verifies the installed Java compiler and Gradle version:

```bash
java -version
javac -version
./gradlew --version
```

The successful environment used:

```text
Java:   21.0.12.1
Gradle: 8.14.4
```

---

## 3. Test

Jenkins executes:

```bash
./gradlew clean test
```

This removes previous build output and runs the project's automated tests.

Successful result:

```text
BUILD SUCCESSFUL
```

---

## 4. Build

The application is built using:

```bash
./gradlew build
```

Gradle generates the application JAR:

```text
build/libs/CodeAlpha_Gradle_Java-1.0.0.jar
```

---

## 5. Archive JAR

Jenkins archives the generated JAR:

```text
build/libs/*.jar
```

This allows the build artifact to be retained and accessed from Jenkins.

---

## 6. Deploy

The pipeline copies the generated JAR to:

```text
/opt/codealpha/
```

It then executes:

```bash
java -jar /opt/codealpha/CodeAlpha_Gradle_Java-1.0.0.jar
```

Successful deployment produces:

```text
Hello from CodeAlpha Gradle CI/CD!
```

---

# 📜 Jenkinsfile

The pipeline uses:

```groovy
pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Java & Gradle') {
            steps {
                sh '''
                    java -version
                    javac -version
                    ./gradlew --version
                '''
            }
        }

        stage('Test') {
            steps {
                sh './gradlew clean test'
            }
        }

        stage('Build') {
            steps {
                sh './gradlew build'
            }
        }

        stage('Archive JAR') {
            steps {
                archiveArtifacts artifacts: 'build/libs/*.jar', fingerprint: true
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    mkdir -p /opt/codealpha
                    cp build/libs/CodeAlpha_Gradle_Java-1.0.0.jar /opt/codealpha/
                    java -jar /opt/codealpha/CodeAlpha_Gradle_Java-1.0.0.jar
                '''
            }
        }
    }
}
```

---

# 🚀 Running the Application Locally

Clone the repository:

```bash
git clone https://github.com/Bravojonasco1/CodeAlpha_Gradle_Java.git
```

Enter the project:

```bash
cd CodeAlpha_Gradle_Java
```

Make the Gradle wrapper executable if necessary:

```bash
chmod +x gradlew
```

Run the tests:

```bash
./gradlew clean test
```

Build the application:

```bash
./gradlew build
```

Run the generated JAR:

```bash
java -jar build/libs/CodeAlpha_Gradle_Java-1.0.0.jar
```

Expected output:

```text
Hello from CodeAlpha Gradle CI/CD!
```

---

# ☁️ AWS Jenkins Environment

Jenkins was deployed on an Amazon Linux 2023 EC2 instance.

The server was configured with:

* Java 21 Amazon Corretto
* Java development tools
* Git
* Jenkins
* Gradle Wrapper supplied by the project

Jenkins was accessed through port:

```text
8080
```

The Jenkins server was used for both CI and deployment in this demonstration.

---

# 🐛 Troubleshooting

Several issues were encountered during implementation. Documenting these issues demonstrates the troubleshooting and problem-solving aspect of the DevOps workflow.

## 1. Jenkins could not connect to GitHub

### Error

```text
Failed to connect to repository:
Error performing git command:
git ls-remote
```

### Cause

Git was not installed on the Jenkins EC2 server.

Running:

```bash
git --version
```

returned:

```text
-bash: git: command not found
```

### Solution

Git was installed using:

```bash
sudo dnf install git -y
```

The installation was verified:

```bash
git --version
```

Result:

```text
git version 2.50.1
```

GitHub connectivity was then tested with:

```bash
git ls-remote https://github.com/Bravojonasco1/CodeAlpha_Gradle_Java.git HEAD
```

The repository successfully returned the remote commit reference.

---

## 2. Gradle could not find the Java compiler

### Error

```text
Toolchain installation '/usr/lib/jvm/java-21-amazon-corretto.x86_64'
does not provide the required capabilities: [JAVA_COMPILER]
```

### Cause

Java 21 was installed, but the Java development package containing `javac` was missing.

### Solution

The Java 21 development package was installed:

```bash
sudo dnf install java-21-amazon-corretto-devel -y
```

The compiler was verified:

```bash
javac -version
```

Result:

```text
javac 21.0.12.1
```

After restarting Jenkins, the pipeline was able to compile the Java source and tests successfully.

---

## 3. Jenkins Git installation warning

Jenkins displayed:

```text
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
```

Despite the warning, Jenkins successfully detected and executed:

```text
git version 2.50.1
```

The repository was successfully cloned and the pipeline completed successfully.

Because the Git functionality was working, no unnecessary configuration changes were made.

---

## 4. Gradle deprecation warning

Gradle displayed:

```text
Deprecated Gradle features were used in this build,
making it incompatible with Gradle 9.0.
```

This did not cause the build to fail.

The pipeline still returned:

```text
BUILD SUCCESSFUL
```

The warning can be investigated in a future maintenance update using:

```bash
./gradlew build --warning-mode all
```

---

# ✅ Final Pipeline Result

The final Jenkins execution completed successfully:

```text
Checkout              SUCCESS
Verify Java & Gradle  SUCCESS
Test                  SUCCESS
Build                 SUCCESS
Archive JAR           SUCCESS
Deploy                SUCCESS
```

Jenkins reported:

```text
Finished: SUCCESS
```

The deployed application produced:

```text
Hello from CodeAlpha Gradle CI/CD!
```

---

# 🎯 Task 3 Objectives Achieved

This project demonstrates the following DevOps practices:

### Automated Builds

Jenkins automatically executes the Gradle build process.

### Dependency Management

Gradle manages the application's dependencies through `build.gradle`.

### Automated Testing

JUnit tests are executed automatically before the application is packaged.

### Continuous Integration

Source code is retrieved from GitHub and automatically tested and built by Jenkins.

### Continuous Delivery

The generated JAR is archived and deployed automatically by the Jenkins pipeline.

### Infrastructure & Environment Troubleshooting

The project also demonstrates practical troubleshooting involving:

* Git installation
* Jenkins configuration
* Java runtime vs. JDK requirements
* Gradle toolchains
* AWS EC2 configuration
* Jenkins permissions
* GitHub connectivity

---

# 📚 Key DevOps Lessons

This project demonstrates that a successful CI/CD pipeline is more than simply running a build command.

The workflow connects:

```text
Source Control
      ↓
Automation
      ↓
Testing
      ↓
Build
      ↓
Artifact
      ↓
Deployment
      ↓
Verification
```

This approach reduces manual build and deployment steps and provides a repeatable process for delivering Java applications.

---

# 🔗 Project Repository

GitHub:

https://github.com/Bravojonasco1/CodeAlpha_Gradle_Java

---

## 👨‍💻 Author

**Eziorobo John Ezeakpono**

DevOps Engineer

Focus areas:

* AWS
* Linux
* Git & GitHub
* Jenkins
* Docker
* Terraform
* Ansible
* Java/Gradle
* CI/CD

