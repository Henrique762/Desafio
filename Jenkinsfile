pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }
    stages{
        stage ('BuildImage-PRD') {
            steps {
                script {
                    dockerappa = docker.build("henrique77/appa", '-f ./desafio4/prd/contapp/appa/Dockerfile ./desafio4/contapp/appa')
                    dockerappb = docker.build("henrique77/appb", '-f ./desafio4/prd/contapp/appb/Dockerfile ./desafio4/contapp/appb')
                    dockerappc = docker.build("henrique77/appc", '-f ./desafio4/prd/contapp/appc/Dockerfile ./desafio4/contapp/appc')
                    dockerappd = docker.build("henrique77/appd", '-f ./desafio4/prd/contapp/appd/Dockerfile ./desafio4/contapp/appd')
                }  
            }
        }

        stage ('BuildImage-DEV') {
            steps {
                script {
                    dockerappadv = docker.build("henrique77/dev-appa", '-f ./desafio4/dev/contapp/appa/Dockerfile ./desafio4/contapp/appa')
                    dockerappbdv = docker.build("henrique77/dev-appb", '-f ./desafio4/dev/contapp/appb/Dockerfile ./desafio4/contapp/appb')
                    dockerappcdv = docker.build("henrique77/dev-appc", '-f ./desafio4/dev/contapp/appc/Dockerfile ./desafio4/contapp/appc')
                    dockerappddv = docker.build("henrique77/dev-appd", '-f ./desafio4/dev/contapp/appd/Dockerfile ./desafio4/contapp/appd')
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

        stage ('Push Image PRD') {
            steps {
                script {
                    dockerappa.push('latest')
                    dockerappb.push('latest')
                    dockerappc.push('latest')
                    dockerappd.push('latest')
                }
            } 
        }
        stage ('Push Image DEV') {
            steps {
                script {
                    dockerappadv.push('latest')
                    dockerappbdv.push('latest')
                    dockerappcdv.push('latest')
                    dockerappddv.push('latest')
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
                        kubectl delete deployments app-a-dev app-b-dev app-c-dev app-d-dev -n dev
                        kubectl apply -f ./desafio4/prd/k8s/deployments/appa_deployments.yaml
                        kubectl apply -f ./desafio4/prd/k8s/deployments/appb_deployments.yaml
                        kubectl apply -f ./desafio4/prd/k8s/deployments/appc_deployments.yaml
                        kubectl apply -f ./desafio4/prd/k8s/deployments/appd_deployments.yaml
                        kubectl apply -f ./desafio4/dev/k8s/deployments/appa_deployments.yaml
                        kubectl apply -f ./desafio4/dev/k8s/deployments/appb_deployments.yaml
                        kubectl apply -f ./desafio4/dev/k8s/deployments/appc_deployments.yaml
                        kubectl apply -f ./desafio4/dev/k8s/deployments/appd_deployments.yaml              


                        
                        '''
                }
           }
        }
    }
}