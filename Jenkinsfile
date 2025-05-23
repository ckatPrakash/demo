pipeline {
    agent any 
        environment {
            AWS_region = "us-east-1"
        }
    stages  {
	stage('git checkout') {
		steps {
		script {
		git branch "main" 'url 'https://github.com/ckatPrakash/demo.git'
		}
		}
	}
        stage("Run Terraform commands") {
            steps {
            withCredentials([usernamePassword(credentialsId: "jenkins_id", usernameVariable: 'AWS_access_key_id', passwordVariable: 'AWS__SECRET_ACCESS_KEY')]) {
            sh '''
             export AWS_region  
             terraform init
             terraform plan
             terraform update
            '''
            }
        } 
    }
    
}
}
