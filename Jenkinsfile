pipeline {
	agent any
	stages {
		stage('Create the cluster for Kubernetes') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws_credentials') {
					sh '''
						eksctl create cluster \
						--name capstonecluster \
						--version 1.13 \
						--nodegroup-name standard-workers \
						--node-type t2.small \
						--nodes 2 \
						--nodes-min 1 \
						--nodes-max 3 \
						--node-ami auto \
						--region us-west-2 \
						--zones us-west-2a \
						--zones us-west-2b \
						--zones us-west-2c \
					'''
				}
			}
		}
		stage('Create conf file for cluster') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws_credentials') {
					sh '''
						aws eks --region us-west-2 update-kubeconfig --name capstonecluster
					'''
				}
			}
		}
	}
}
