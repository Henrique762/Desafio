pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }
    stages{
        stage ('Build Images') {
            steps {
                script {
                    dockerappa = docker.build("henrique77/appa", '-f ./desafio4/contapp/appa/Dockerfile ./desafio4/contapp/appa')
                    dockerappb = docker.build("henrique77/appb", '-f ./desafio4/contapp/appb/Dockerfile ./desafio4/contapp/appb')
                    dockerappc = docker.build("henrique77/appc", '-f ./desafio4/contapp/appc/Dockerfile ./desafio4/contapp/appc')
                    dockerappd = docker.build("henrique77/appd", '-f ./desafio4/contapp/appd/Dockerfile ./desafio4/contapp/appd')
                }  
            }
        }

        stage ('Login Docker') {
            steps   {
                script {
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                }
            }
        }

        stage ('Push Image') {
            steps {
                script {
                    dockerappa.push('latest')
                    dockerappb.push('latest')
                    dockerappc.push('latest')
                    dockerappd.push('latest')
                }
            } 
        }    
        stage ('Deploy-k8s') {
            steps {
                script  {
                    sh '''
                        
                        export AWS_PROFILE=default
                        aws eks update-kubeconfig --name cluster-desafio
                        kubectl delete deployments app-a app-b app-c app-d
                        kubectl apply -f ./desafio4/k8s/deployments/.
                        kubectl apply -f ./desafio4/k8s/ingress/.
                        kubectl apply -f ./desafio4/k8s/services/.              


                        
                        '''
                }
           }
        }
    }
}