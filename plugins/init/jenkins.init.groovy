#!groovy
import jenkins.model.Jenkins;

def env = System.getenv()
def jenkins_home = env.JENKINS_HOME

def file = new File(jenkins_home, "jenkins.state")
file.withWriter('utf-8') { writer ->
    writer.writeLine 'Success'
}