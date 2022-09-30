# Github Runners

GitHub Actions automates the deployment of code to different environments, including production. The environments contain the `GitHub Runner` software which executes the automation. `GitHub Runner` can be run in GitHub-hosted cloud or self-hosted environments. Self-hosted environments offer more control of hardware, operating system, and software tools. They can be run on physical machines, virtual machines, or in a container. Containerized environments are lightweight, loosely coupled, highly efficient and can be managed centrally. However, they are not straightforward to use.

## Getting Started

### Prerequisites

<details><summary><sub>Create a K8s cluster, if not available.</sub></summary>
   <sub>
If you don't have a K8s cluster, you can install a local environment using minikube. For more information, see <a href="https://minikube.sigs.k8s.io/docs/start/">"Installing minikube."</a>
   </sub>
</details>
<details><summary><sub>Create the Actions Runner Controller on your K8s Cluster</sub></summary>
   <sub>
The instalation guide I used can be found here <a href="https://github.com/actions-runner-controller/actions-runner-controller#readme">"Installing ARC."</a>
   </sub>
</details> 
<details><summary><sub>Create an image for the Runner you intend to use</sub></summary>
   <sub>
For my LaTex resume builder I created the <a href="https://github.com/brandencward/runners/tree/main/resume-runner-arm">"resume-runner-arm."</a> image. This code can be used as an example.
   </sub>
</details>    
<br/>

### Setup   

For the self hosted runners I use the `Actions Runner Controller (ARC)` found [here](https://github.com/actions-runner-controller/actions-runner-controller#readme).

I then create my own RunnerDeployment in Kubernes for the Repo I am using it for. I named the yaml file resume-runner-arm.yaml

```
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: resume-runner-arm
  namespace: github-runners
spec:
  replicas: 1
  template:
    spec:
      repository: YOUR_REPOSITORY
      image: YOUR_RUNNER_IMAGE
      imagePullPolicy: IfNotPresent
      dockerEnabled: false
      ephemeral: true
      labels:
        - "RUNNER_LABEL_TO_TRIGGER_ON"
```
Apply your new yaml file
```
kubectl apply -f resume-runner-arm.yaml
```
Check your new deployment and pods
```
kubectl get RunnerDeployment,pods -n github-runners
```
Verify your new runner in Github. 

Go to your Repo > Settings > Actions > Runners

You should see your new self hosted runner with the name of your container.

You can now create github actions for that repository that utilze your new self hosted runner. Simply add this line to the Github Action.

```
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: [self-hosted, RUNNER_LABEL_TO_TRIGGER_ON]
```