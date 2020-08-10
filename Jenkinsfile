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
        stage('Security Scan') {
            steps {
                sudo aquaMicroscanner imageName: 'alpine:latest', notCompleted: 'exit 1', onDisallowed: 'fail'
                sudo aquaMicroscanner imageName: "raghuchandan1/devops-capstone", notCompliesCmd: '', onDisallowed: 'ignore', outputFormat: 'html'
            }
        }         
        
        stage('Deploy') { 
            steps {
                sh 'echo Deploying the Docker Image' 
            }
        }
    }
}