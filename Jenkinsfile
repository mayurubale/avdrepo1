pipeline{
    agent any
    stages{
        stage('Checkout code'){
            steps{
                git url:'https://github.com/mayurubale/avdrepo1.git', branch: 'main'
            }
        }
        stage('Build Image'){
            steps{
                bat 'docker build -t myimage'
            }

        }
        stage('create container'){
            steps{
                bat 'docker run -d -p 8502:8501 myimage'
            }
        }
    }
}