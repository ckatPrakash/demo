pipeline {
    agent any 
        environment {
            AWS_region = "us-east-1"
	    AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
            AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY_ID')
  }	
    stages  {
	stage('git checkout') {
		steps {
			git branch: 'main', url: 'https://github.com/ckatPrakash/demo.git'
		}
	}
	stage ('Terraform Init') {
		steps {
			sh 'terraform init'
		}
	}
	stage ('Terraform plan') {
		steps {
			sh 'terraform plan -out tfplan'
		}
	}
	 
	stage('User Confirmation') {
            steps {
                script {
                    def userChoice = input message: 'Choose Terraform action:', parameters: [
                        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select action')
                    ]
                    env.USER_ACTION = userChoice
                }
            }
        }
	stage ('Terraform apply/destroy') {
		steps {
			script {
			input message: "Are you sure you want to '${env.USER_ACTION}'?" 
			if (env.USER_ACTION == 'apply'){
			sh 'terraform apply -input=false -auto-approve -lock=false tfplan'
			}
			if (env.USER_ACTION == 'destroy') {
			sh 'terraform destroy -auto-approve'
			}	
		}
	}
	}	
}
}
