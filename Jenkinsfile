pipeline {
    agent any
    parameters {
        string(name: 'VERSION', description: 'version string for stellar-core .deb package') 
        string(name: 'BUILDNUM', description: 'build number of jenkins job thats on the .deb package')
    }
    environment {
        VERSION = "${params.VERSION}-${params.BUILDNUM}"
        TEST_VERSION = "${params.VERSION}~buildtests-${params.BUILDNUM}"
        OLD_IMAGE = "${params.OLD_IMAGE}"
        DOCKER_REGISTRY = "docker-registry.services.stellar-ops.com/dev/stellar-core"

        // Docker tags can't use ~
        NEW_IMAGE = "${DOCKER_REGISTRY}:${VERSION.replaceAll('~', '-')}"
        NEW_TEST_IMAGE = "${DOCKER_REGISTRY}:${TEST_VERSION.replaceAll('~', '-')}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "master" ]],
                    userRemoteConfigs: [[url: "git@github.com:sisuresh/docker-stellar-core-v2.git"]]
                ])
            }
        }
        stage('Build BUILD_TESTS') {
            steps {
                sh '''
                    set -e
                    
                    docker build --build-arg STELLAR_CORE_VERSION=${TEST_VERSION} --pull -t ${NEW_TEST_IMAGE} .

                    docker push ${NEW_TEST_IMAGE}
                '''
            }
        }
        stage('Build without BUILD_TESTS') {
            steps {
                sh '''
                    set -e
                    
                    docker build --build-arg STELLAR_CORE_VERSION=${VERSION} --pull -t ${NEW_IMAGE} .

                    docker push ${NEW_IMAGE}
                '''
            }
        }
    } 
    post {
        success {
            build job: 'stellar-supercluster-siddtest', wait: false, parameters: [string(name: 'NEW_IMAGE', value: "${NEW_IMAGE}"), string(name: 'NEW_IMAGE_WITH_TEST', value: "${NEW_TEST_IMAGE}"), booleanParam(name: 'BUILD_TESTS_ENABLED', value: true)]
        }
    }
}