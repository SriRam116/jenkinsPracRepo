pipeline{
    agent any

    environment{
        KEY = "pipeKey"
    }

    stages {
        stage('Clone repo'){
            steps {
                git 'https://github.com/SriRam116/jenkinsPracRepo.git'
            }
        }
        
        stage('Terraform init'){
            steps{
                dir('terraform'){
                    sh 'terraform init'
                    }
                }
            }

        stage('Terraform apply'){
            steps{
                dir('terraform')
                sh 'terraform apply -auto-approve'
            }
        }

        stage('get public IP'){
            steps{
                script{
                    EC2_IP = sh(
                        script: "cd terraform && terraform output -raw public_ip"
                        returnStdout: true
                    ).trim()

                    sh """
                    cat <<EOF> ansible/inventory.yml
                    all:
                     hosts:
                      pipeline:
                       ansible_host: ${EC2_IP}
                       ansible_user: ubuntu
                       ansible_ssh_private_key_file: ${KEY}
                    EOF
                    """
                }
            }
        }

        stage('wait for ssh'){
            steps{
                sh 'sleep 60'
            }
        } 

        stage('run Ansible'){
            steps{
                sh 'ansible-playbook -i ansible/inventory ansible/setup.yml'
            }
        }
        }
    
    post{
        always{
            echo "done"
        }
        success{
            echo "Successful"
        }
        failure{
            echo "Failed"
        }
    }
}