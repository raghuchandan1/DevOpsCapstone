pipeline {
	agent any
	stages {
		stage('Create the cluster for Kubernetes') {
			steps {
				sh '''
					aws configure set aws_access_key_id AKIAUIAZSVB5RUZL4EVX
					aws configure set aws_secret_access_key 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
					aws configure set region us-west-2
					aws configure set output json
					eksctl create cluster \
					--name devopscapstonecluster \
					--version 1.17 \
					--nodegroup-name standard-workers \
					--node-type t2.small \
					--nodes 2 \
					--nodes-min 1 \
					--nodes-max 3 \
					--node-ami auto \
					--region us-west-2 \
					--zones us-west-2a --zones us-west-2b --zones us-west-2c
				'''
	
			}
		}
		stage('Create conf file for cluster') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws_credentials') {
					sh '''
						aws eks --region us-west-2 update-kubeconfig --name devopscapstonecluster
					'''
				}
			}
		}
	}
}
