pipeline {
    agent any

    environment {
        KEY = "pipeKey"
    }

    stages {

        stage('Clone repo') {
            steps {
                git branch: 'main', url: 'https://github.com/SriRam116/jenkinsPracRepo.git'
            }
        }

        stage('Terraform init') {
            steps {
                dir('terraform') {
                    bat '"C:\\Program Files\\Git\\bin\\bash.exe" -c "terraform init"'
                }
            }
        }

        stage('Terraform apply') {
            steps {
                dir('terraform') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'pipePrac'
                        ],
                        file(credentialsId: 'ssh-pub-key', variable: 'PUB_KEY')]) {
                            script{
                                def pubKey = readFile(PUB_KEY).trim()
                                withEnv(["TF_VAR_public_key=${pubKey}"]){
                                    bat '''
                                    terraform apply -auto-approve
                                    '''
                                }   
                            }
                     }
                 }
              }
        }

        stage('Get Public IP') {
            steps {
                script {
                    EC2_IP = bat(
                        script: '"C:\\Program Files\\Git\\bin\\bash.exe" -c "cd terraform && terraform output -raw awsPubIP"',
                        returnStdout: true
                    ).trim()

                    withCredentials([sshUserPrivateKey(credentialsId: 'ssh-private-key', keyFileVariable: 'SSH_KEY')]) {
    bat """
    "C:\\Program Files\\Git\\bin\\bash.exe" -c "cat <<EOF > ansible/inventory.yml
all:
  hosts:
    pipeline:
      ansible_host: ${EC2_IP}
      ansible_user: ubuntu
      ansible_ssh_private_key_file: $SSH_KEY
EOF"
    """
}
                }
            }
        }

        stage('Wait for SSH') {
            steps {
                bat '"C:\\Program Files\\Git\\bin\\bash.exe" -c "sleep 60"'
            }
        }

        stage('Run Ansible') {
            steps {
                bat '"C:\\Program Files\\Git\\bin\\bash.exe" -c "ansible-playbook -i ansible/inventory.yml ansible/setup.yml"'
            }
        }
    }

    post {
        always {
            echo "done"
        }
        success {
            echo "Successful"
        }
        failure {
            echo "Failed"
        }
    }
}