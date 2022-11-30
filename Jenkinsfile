pipeline {
    agent any

    //environment {
        //DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    //}
    stages{
        stage ('BuildImage-A') {
            steps {
                script {
                    dockerappa = docker.build("henrique77/appa", '-f ./desafio4/contapp/appa/Dockerfile ./desafio4/contapp/appa')
                    //dockerappb = docker.build("henrique77/appb", '-f ./appb/Dockerfile ./appb')
                    //dockerappc = docker.build("henrique77/appc", '-f ./appc/Dockerfile ./appc')
                    //dockerappd = docker.build("henrique77/appd", '-f ./appd/Dockerfile ./appd')
                }  
            }
        }

        //stage ('Login Docker') {
           // steps   {
                //script {
                    //sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                //}
           // }
        //}

        //stage ('Push Image A') {
            //steps {
                //script {
                           // dockerappa.push('latest')
                           // dockerappb.push('latest')
                           // dockerappc.push('latest')
                           // dockerappd.push('latest')
               // }
            //} 
        //}    
        //stage ('Deploy-k8s') {
            //steps {
                //script  {
                    //sh '''
                        
                        //export AWS_PROFILE=default
                        //aws eks update-kubeconfig --name cluster-desafio
                        //kubectl delete deployments app-a app-b
                        //kubectl apply -f ./k8s/deployments/appa_deployments.yaml
                       // kubectl apply -f ./k8s/deployments/appb_deployments.yaml
                       // kubectl apply -f ./k8s/deployments/appc_deployments.yaml
                        //kubectl apply -f ./k8s/deployments/appd_deployments.yaml              


                        
                       // '''
                //}
           //}
       // }
    }
}