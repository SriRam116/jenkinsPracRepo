pipeline {
    agent any

    environment {
        KEY = "wslssh"
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
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform apply') {
            steps {
                dir('terraform') {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'pipePrac'],
                        file(credentialsId: 'wslpublic', variable: 'PUB_KEY')
                    ]) {
                        script {
                            def pubKey = readFile(PUB_KEY).trim()
                            withEnv(["TF_VAR_public_key=${pubKey}"]) {
                                sh 'terraform apply -auto-approve'
                            }
                        }
                    }
                }
            }
        }

        stage('Deploy with Ansible') {
    steps {
        script {
            def EC2_IP = sh(
                script: "cd terraform && terraform output -raw awsPubIP",
                returnStdout: true
            ).trim()

            withCredentials([
                sshUserPrivateKey(credentialsId: 'ansible_SSH', keyFileVariable: 'SSH_KEY')
            ]) {

                // Create inventory
                writeFile file: 'ansible/inventory.yml', text: """
all:
  hosts:
    pipeline:
      ansible_host: ${EC2_IP}
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ${SSH_KEY}
      ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
"""

                // Debug (optional)
                sh "ls -l ${SSH_KEY}"

                // Run Ansible
                sh """
                ansible-playbook -i ansible/inventory.yml ansible/setup.yml
                """
            }
        }
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
            echo "Failed - Destroying infrastructure..."

            dir('terraform') {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'pipePrac']
                ]) {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}