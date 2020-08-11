pipeline {
    agent any 
    stages {
        stage('Lint HTML') {
            steps {
                sh 'sudo apt-get install -y tidy'
                sh 'tidy -q -e *.html'
            }
        }
        stage('Lint Docker') {
            steps {
                // sh 'sudo docker run hello-world'
                sh 'sudo docker run --rm -i hadolint/hadolint:latest < Dockerfile'
            }
        }
        
        stage('Build Docker Image') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
					sh '''
						sudo docker build -t raghuchandan1/devops-capstone .
					'''
				}
			}
		}

		stage('Push Image To Dockerhub') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
					sh '''
						sudo docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
						sudo docker push raghuchandan1/devops-capstone
					'''
				}
			}
		}
        //stage('Security Scan') {
        //    steps {
        //        sudo aquaMicroscanner imageName: "raghuchandan1/devops-capstone", notCompliesCmd: '', onDisallowed: 'ignore', outputFormat: 'html'
        //    }
        //}         
        
        stage('Deploy') { 
            steps {
                sh 'echo Deploying the Docker Image' 
            }
        }
	    
        stage('Set current kubectl context') {
		steps {
			withAWS(region:'us-west-2', credentials:'aws_credentials') {
				sh '''
					kubectl config use-context arn:aws:eks:us-west-2:292111427707:cluster/devopscapstonecluster
				'''
			}
		}
	}

	stage('Deploy blue container') {
		steps {
			withAWS(region:'us-west-2', credentials:'aws_credentials') {
				sh '''
					kubectl apply -f ./blue-controller.json
				'''
			}
		}
	}

	stage('Deploy green container') {
		steps {
			withAWS(region:'us-west-2', credentials:'aws_credentials') {
				sh '''
					kubectl apply -f ./green-controller.json
				'''
			}
		}
	}

	stage('Create the service in the cluster, redirect to blue') {
		steps {
			withAWS(region:'us-west-2', credentials:'aws_credentials') {
				sh '''
					kubectl apply -f ./blue-service.json
				'''
			}
		}
	}

	stage('Wait user approve') {
    steps {
	input "Ready to redirect traffic to green?"
    }
}

	stage('Create the service in the cluster, redirect to green') {
		steps {
			withAWS(region:'us-west-2', credentials:'aws_credentials') {
				sh '''
					kubectl apply -f ./green-service.json
				'''
			}
		}
	}
    }
}
