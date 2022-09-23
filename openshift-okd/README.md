# MongoDB Kubernetes Operator + OpenShift OKD

Scripts to deploy 1) an OKD Kubernetes cluster and 2) the MongoDB Enterprise Kubernetes Operator and MongoDB database resources to that cluster. Uses both the standard MongoDB Kubernetes Operator container images hosted on Quay.io and the hardened images deployed to Platform One. 

## Prerequisites

This repo is configured to deploy OKD to AWS using installer-provisioned resources. That is to say, the OKD installer will provision all necessary resources on AWS. To do that requires an AWS account with appropriate permissions. Since those permissions may exceed those available in typical use, the scripts use a named AWS CLI profile. The special purpose aws_access_key_id/aws_secret_access_key for this effort can be stored in a separate profile (e.g. "personal") in ~/.aws/credentials.

The OKD deployment also requires a public domain name under your control that is registered with AWS Route 53.


