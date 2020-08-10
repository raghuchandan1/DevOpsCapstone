pipeline {
    agent any 
    stages {
        stage('Lint HTML') {
            steps {
                //sh 'apt-get install tidy'
                sh 'tidy -q -e *.html'
            }
        }
        stage('Lint Docker') {
            steps {
                sh 'docker run --rm -i hadolint/hadolint:latest < Dockerfile'
            }
        }
        
        stage('Build Docker Image') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
					sh '''
						docker build -t raghuchandan1/devops-capstone .
					'''
				}
			}
		}

		stage('Push Image To Dockerhub') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
					sh '''
						docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
						docker push raghuchandan1/devops-capstone
					'''
				}
			}
		}
        stage('Security Scan') {
            steps { 
                aquaMicroscanner imageName: 'devops-capstone', notCompliesCmd: 'exit 1', onDisallowed: 'fail', outputFormat: 'html'
            }
        }         
        
        stage('Deploy') { 
            steps {
                sh 'echo Deploying' 
            }
        }
    }
}