# CodeAlpha Task 2: Jenkins Remoting Project

**Author:** Eziorobo John Ezeakpono  
**Project:** CodeAlpha DevOps Internship — Task 2  
**Platform:** AWS EC2, Jenkins, Amazon Linux 2023, Java 21  
**Status:** Remote Jenkins agent execution demonstrated

## Project Overview

This project demonstrates Jenkins Remoting by connecting a Jenkins controller and a separate Jenkins agent hosted on different Amazon EC2 instances. A pipeline is assigned to the agent so its build steps execute on the remote machine rather than on the controller.

The goal is to understand distributed build execution, agent configuration, workspace isolation, connectivity, and troubleshooting in a practical AWS environment.

## Objectives

- Configure a Jenkins controller and a remote Jenkins agent.
- Execute pipeline jobs on a designated remote node.
- Verify the remote machine's hostname, private IP, operating system, user, Java version, and workspace.
- Separate build execution from the controller machine.
- Document the setup and common connection issues.

## Architecture

```text
                         AWS VPC
                    (private networking)

   Jenkins Controller                 Jenkins Agent
   EC2 instance                       EC2 instance
   Private IP: 10.0.0.61              Private IP: 10.0.0.109
   Jenkins UI / scheduling            Executes pipeline steps
             |                                  ^
             |       Jenkins Remoting           |
             +----------------------------------+
                     Secure node connection
```

The controller schedules the pipeline and manages the job. The agent performs the build steps in its own workspace. The two private IP addresses are for communication within the relevant AWS network; they are not public internet addresses.

## Environment

| Component | Configuration |
|---|---|
| Cloud provider | AWS |
| Compute | Separate EC2 instances |
| Operating system | Amazon Linux 2023 |
| Java | Java 21 (Corretto 21 in the project environment) |
| CI/CD tool | Jenkins |
| Controller private IP | `10.0.0.61` |
| Agent private IP | `10.0.0.109` |
| Agent label | `remote-agent` |
| Agent workspace example | `/home/ec2-user/jenkins-agent/workspace/` |

> **Security note:** Private IPs are included for project documentation. Do not commit private keys, passwords, access tokens, Jenkins secrets, or other credentials to GitHub. Restrict security-group rules to the required sources and ports.

## How It Works

1. Jenkins is installed and running on the controller EC2 instance.
2. A separate EC2 instance is configured as the Jenkins agent.
3. The agent is registered in Jenkins and assigned the label `remote-agent`.
4. The pipeline selects that label using `agent { label 'remote-agent' }`.
5. Jenkins schedules the job on the matching agent.
6. Pipeline commands execute on the agent, and the console output reports details of the remote environment.

## Pipeline Example

The project pipeline verifies that the job is running on the expected remote machine.

```groovy
pipeline {
    agent {
        label 'remote-agent'
    }

    stages {
        stage('Verify Remote Agent') {
            steps {
                sh '''
                    echo "Hostname: $(hostname)"
                    echo "Private IP addresses:"
                    hostname -I
                    echo "User: $(whoami)"
                    echo "Operating system:"
                    cat /etc/os-release
                    echo "Java version:"
                    java -version
                    echo "Workspace: $PWD"
                '''
            }
        }
    }
}
```

Use the pipeline file committed in this repository as the source of truth if its stage names or commands differ from this illustrative excerpt.

## Validation and Evidence

A successful run showed Jenkins executing the job on the remote node:

```text
Running on jenkins-agent in /home/ec2-user/jenkins-agent/workspace/...
```

The remote environment output identified the agent as an Amazon Linux 2023 EC2 host, running as `ec2-user` with Java 21. The job also printed its hostname, private IP information, and working directory.

These results demonstrate that the pipeline ran on the agent rather than in the controller's local workspace.

For a submission, include screenshots of:
- The Jenkins node configuration showing the agent online and its label.
- A successful pipeline console log showing `Running on jenkins-agent`.
- The remote environment details printed by the pipeline.
- The repository and README.

## Security and Isolation Considerations

- Keep the controller and agent on separate EC2 instances.
- Use private networking for controller-agent communication where possible.
- Limit inbound security-group rules to trusted sources and only the required ports.
- Protect SSH private keys and Jenkins credentials; never store them in the repository.
- Use a dedicated agent account and workspace, and avoid granting unnecessary privileges.
- Keep the controller, agent operating system, Java, and Jenkins components patched.

Running builds on a separate agent provides machine-level separation from the controller. It is not, by itself, a complete security sandbox: agent jobs may still access resources and credentials available to the agent account. Stronger isolation may require disposable agents, restricted permissions, and additional controls.

## Troubleshooting Notes

### Agent does not connect
- Confirm that both EC2 instances are running and can communicate over the VPC network.
- Verify the agent launch method and its connection settings in Jenkins.
- Check security-group and host firewall rules for the configured connection method.
- Review the Jenkins controller and agent logs for connection errors.

### SSH host-key verification or `known_hosts` errors
- Ensure the Jenkins service account has a valid SSH configuration directory and correct ownership/permissions if SSH launch is used.
- Add and verify the intended host key using your organization's trusted host-key verification process.
- Do not disable host-key verification as a shortcut.

### Job runs on the controller instead of the agent
- Confirm the pipeline uses the exact agent label configured in Jenkins, such as `remote-agent`.
- Confirm the agent is online and has available executors.
- Inspect the console log for the node and workspace used by the run.

### Java compatibility
- Check the Java version required by the installed Jenkins release and ensure the controller/agent setup meets the applicable requirements.

## Requirements Coverage

| Task requirement | Evidence / outcome |
|---|---|
| Set up Jenkins Remoting to connect remote nodes | A separate EC2 agent was configured in Jenkins. |
| Distribute build loads across machines securely | The pipeline was assigned to the separate agent machine. This demonstrates remote execution; capacity/load balancing across multiple agents was not benchmarked. |
| Run jobs on various architectures remotely | Remote execution on a separate EC2 host was demonstrated. Multiple CPU architectures (for example, x86_64 and ARM64) were not tested. |
| Improve security using node isolation | Build execution was separated from the controller at the EC2-machine level. Additional sandboxing and security testing were not claimed. |
| Gain practical experience with Jenkins remote execution | The node, pipeline label, remote workspace, environment checks, and troubleshooting were exercised. |

## Limitations and Future Improvements

- Add a second agent and demonstrate workload distribution across multiple agents.
- Test agents with different CPU architectures, such as x86_64 and ARM64, if required by the assessment.
- Add screenshots and a short demonstration video to the repository.
- Consider ephemeral agents and stricter least-privilege controls for production-like isolation.

## Conclusion

This project demonstrates the core Jenkins Remoting workflow: a controller schedules a pipeline, a separate EC2 agent executes it, and the console log verifies the remote execution environment. It provides practical experience with node configuration, agent labels, remote workspaces, AWS networking, and troubleshooting.

---

**Repository:** `https://github.com/Bravojonasco1/CodeAlpha_JenkinsRemoting`

