#!/bin/bash

echo "===== JENKINS REMOTE AGENT TEST ====="

echo "Hostname:"
hostname

echo "Private IP:"
hostname -I

echo "Current user:"
whoami

echo "Operating System:"
grep PRETTY_NAME /etc/os-release

echo "Java version:"
java -version

echo "Working directory:"
pwd

echo "===== REMOTE EXECUTION SUCCESSFUL ====="
