pipeline {
    agent any

    environment {
        // Credentials ID from AWS Credentials Plugin
        AWS_ACCESS_KEY_ID = credentials('access-key')
        AWS_SECRET_ACCESS_KEY = credentials('secret-key')
        ECR_REPOSITORY_URI= '796973496394.dkr.ecr.ca-central-1.amazonaws.com'
        AWS_REGION = 'ca-central-1'
    }

    stages {
         stage('Build Docker Image front') {
             steps {
               
                 sh 'docker build -t ${ECR_REPOSITORY_URI}/headway:front-${BUILD_NUMBER} ./app/frontend/.'
                 sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY_URI}'
                 sh 'docker push ${ECR_REPOSITORY_URI}/headway:front-${BUILD_NUMBER}'
             }
         }
         stage('Build Docker Image back') {
             steps {
                 sh 'docker build -t ${ECR_REPOSITORY_URI}/headway:back-${BUILD_NUMBER} ./app/backend/.'
                 sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY_URI}'
                 sh 'docker push ${ECR_REPOSITORY_URI}/headway:back-${BUILD_NUMBER}'
             }
         }
         stage('Kubernetes Edit Files') {
             steps {
                    sh "sed -i 's|image:.*|image: ${ECR_REPOSITORY_URI}/headway:back-${BUILD_NUMBER}|g' ./k8s/backend.yaml"
                    sh "sed -i 's|image:.*|image: ${ECR_REPOSITORY_URI}/headway:front-${BUILD_NUMBER}|g' ./k8s/frontend.yaml"
                      sh "aws eks update-kubeconfig --region ca-central-1 --name master-eks "
             }
        }

        
        stage('apply database') {
            steps {
             
                 sh 'kubectl apply -f ./k8s/secret.yaml '  
                 sh 'kubectl apply -f ./k8s/configmap.yaml '
                 sh 'kubectl apply -f ./k8s/postgress_serves.yaml '
                 sh 'kubectl apply -f ./k8s/postgress.yaml '  
            }
        }

        stage('apply backend') {
            steps {
                  sh 'kubectl apply -f ./k8s/backend.yaml '  
                  sh 'kubectl apply -f ./k8s/backend_service.yaml '  
            }
        }

        stage('apply frontend') {
            steps {
                sh 'kubectl apply -f ./k8s/frontend.yaml '  
                sh 'kubectl apply -f ./k8s/frontend_service.yml '  
            }
        }

    }
}
