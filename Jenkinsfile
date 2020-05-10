pipeline {
	agent any
	stages {
		stage('Lint Dockerfile') {
			steps {
				sh 'hadolint Dockerfile'
			}
		}
		stage('Build Docker Image') {
			steps {
				sh '''
					docker build -t rrishabhbansal96/udacitynd .
				'''
			}
		}

		stage('Push Image To Dockerhub') {
			steps {
				withCredentials([string(credentialsId: 'socker-user', variable: 'dockerpwd')]) {
					sh '''
						docker login -u rrishabhbansal96 -p $dockerpwd
						docker push rrishabhbansal96/udacitynd
					'''
				}
			}
		}

		stage('Set current kubectl context') {
			steps {
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-user']]) {
					sh '''
						kubectl config use-context arn:aws:eks:us-west-2:565836625953:cluster/udacityclusternd
					'''
				}
			}
		}

		stage('Blue-container') {
			steps {
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-user']]) {
					sh '''
						kubectl apply -f ./blue-controller.json
					'''
				}
			}
		}

		stage('Green-container') {
			steps {
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-user']]) {
					sh '''
						kubectl apply -f ./green-controller.json
					'''
				}
			}
		}

		stage('Create the service in the cluster, redirect to blue') {
			steps {
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-user']]) {
					sh '''
						kubectl apply -f ./blue-service.json
					'''
				}
			}
		}

		stage('Wait user approve') {
            steps {
                input "Ready to redirect traffic to green????"
            }
        }

		stage('Create the service in the cluster, redirect to green') {
			steps {
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-user']]) {
					sh '''
						kubectl apply -f ./green-service.json
					'''
				}
			}
		}

	}
	post{
        always {
            sh 'echo "One way or the other, task is completed."'
        }
	}
}
