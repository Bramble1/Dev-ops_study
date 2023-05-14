pipeline {
   agent any

   stages {
      stage('Pull Dwm image from website and install dependcies') {
         steps {
            // Clone repository or perform necessary steps before building
             //sh 'wget https://dl.suckless.org/dwm/dwm-6.2.tar.gz'
             sh "curl -O https://dl.suckless.org/dwm/dwm-6.2.tar.gz"
             sh 'apt-get update'
             sh 'apt-get install -y libx11-dev libxft-dev libxinerama-dev'
             
         }
      }

      stage('Build DWM') {
         steps {
            //sh 'tar xzvf dwm-6.2.tar.gz;rm *.gz'//cd dwm-6.2'
            //sh 'sed -i \'s,FREETYPEINC = ${X11INC}/freetype2,#FREETYPEINC = ${X11INC}/freetype2,g\' config.mk'
            //sh 'make install'
            //sh 'mv dwm /usr/bin'
            sh 'pwd;ls'
            sh 'tar xzvf dwm-6.2.tar.gz;rm *.gz'
            dir("${WORKSPACE}/dwm-6.2") {
                sh 'ls; pwd'
               // Change to the directory containing the build_dwm.sh script
               // Replace "path/to/build_dwm_script" with the correct path
               //sh 'tar xzvf dwm-6.2.tar.gz;rm *.gz'//cd dwm-6.2'
               sh 'sed -i \'s,FREETYPEINC = ${X11INC}/freetype2,#FREETYPEINC = ${X11INC}/freetype2,g\' config.mk'
               sh 'make install'
               //sh 'mv dwm /usr/bin'
            }
         }
      }

      // Add more stages as needed
   }
}
pipeline {
   agent any

   stages {
      stage('Pull Dwm image from website and install dependcies') {
         steps {
            // Clone repository or perform necessary steps before building
             //sh 'wget https://dl.suckless.org/dwm/dwm-6.2.tar.gz'
             sh "curl -O https://dl.suckless.org/dwm/dwm-6.2.tar.gz"
             sh 'apt-get update'
             sh 'apt-get install -y libx11-dev libxft-dev libxinerama-dev'
             
         }
      }

      stage('Build DWM') {
         steps {
            //sh 'tar xzvf dwm-6.2.tar.gz;rm *.gz'//cd dwm-6.2'
            //sh 'sed -i \'s,FREETYPEINC = ${X11INC}/freetype2,#FREETYPEINC = ${X11INC}/freetype2,g\' config.mk'
            //sh 'make install'
            //sh 'mv dwm /usr/bin'
            sh 'pwd;ls'
            sh 'tar xzvf dwm-6.2.tar.gz;rm *.gz'
            dir("${WORKSPACE}/dwm-6.2") {
                sh 'ls; pwd'
               // Change to the directory containing the build_dwm.sh script
               // Replace "path/to/build_dwm_script" with the correct path
               //sh 'tar xzvf dwm-6.2.tar.gz;rm *.gz'//cd dwm-6.2'
               sh 'sed -i \'s,FREETYPEINC = ${X11INC}/freetype2,#FREETYPEINC = ${X11INC}/freetype2,g\' config.mk'
               sh 'make install'
               //sh 'mv dwm /usr/bin'
            }
         }
      }

      // Add more stages as needed
   }
}
pipeline {
   agent any

   stages {
      stage('Pull Dwm image from website and install dependcies') {
         steps {
            // Clone repository or perform necessary steps before building
             //sh 'wget https://dl.suckless.org/dwm/dwm-6.2.tar.gz'
             sh "curl -O https://dl.suckless.org/dwm/dwm-6.2.tar.gz"
             sh 'apt-get update'
             sh 'apt-get install -y libx11-dev libxft-dev libxinerama-dev'
             
         }
      }

      stage('Build DWM') {
         steps {
            //sh 'tar xzvf dwm-6.2.tar.gz;rm *.gz'//cd dwm-6.2'
            //sh 'sed -i \'s,FREETYPEINC = ${X11INC}/freetype2,#FREETYPEINC = ${X11INC}/freetype2,g\' config.mk'
            //sh 'make install'
            //sh 'mv dwm /usr/bin'
            sh 'pwd;ls'
            sh 'tar xzvf dwm-6.2.tar.gz;rm *.gz'
            dir("${WORKSPACE}/dwm-6.2") {
                sh 'ls; pwd'
               // Change to the directory containing the build_dwm.sh script
               // Replace "path/to/build_dwm_script" with the correct path
               //sh 'tar xzvf dwm-6.2.tar.gz;rm *.gz'//cd dwm-6.2'
               sh 'sed -i \'s,FREETYPEINC = ${X11INC}/freetype2,#FREETYPEINC = ${X11INC}/freetype2,g\' config.mk'
               sh 'make install'
               //sh 'mv dwm /usr/bin'
            }
         }
      }

      // Add more stages as needed
   }
}
