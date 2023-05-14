pipeline {
    agent any
    //when to run pipeline script
    triggers 
    {
        //build periodically everyday at 06:00
        cron('0 6 * * *')
    }

    stages {
        stage('Clone Repository') {
            steps {
                sh 'rm -r Schedule/ 2>/dev/null'
                sh 'git clone https://github.com/digitalXmage/Schedule.git'
             

            }
        }

        stage('creating Dockerfile') {
            steps {
                script {
                    def dockerfileContent = """
                        FROM ubuntu:latest
                        LABEL maintainer="sam.dh1997@outlook.com"
                        
                        # Install dependencies
                        RUN apt-get update \\
                            && apt-get install -y gcc \\
                            && rm -rf /var/lib/apt/lists/*
                        
                        # Copy source code
                        COPY . /app
                        WORKDIR /app
                        
                        # Compile the program
                        RUN gcc -W -g -lm functions.h functions.c schedule.c -o schedule
                        
                        # Set the entry point
                        ENTRYPOINT ["/app/schedule"]
                        """

                    writeFile file: 'Dockerfile', text: dockerfileContent
                }
            }
        }

        // Add more stages or steps as needed
      stage('Build Docker Image') {
            steps {
                script {
                    def imageName = 'schedule'
                    def dockerfile = 'Dockerfile' // Update the path as per your repository structure

                    // Build the Docker image
                    docker.build(imageName, "-f ${dockerfile} .")
                }
            }
        }
    }
}
