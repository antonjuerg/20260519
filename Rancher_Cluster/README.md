# Rancher Install

Rancher has been installed on the MacBook like this:

> sudo docker run --privileged -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher

> docker logs  02d60ce34a92  2>&1 | grep "Bootstrap Password:"

> 2026/04/10 07:33:41 [INFO] Bootstrap Password: g57c9l7p6n7r8wcw78cs6sdfcdmh5vczl5cllzlw4nf456sf6xnw8b

## Base Infos
Rancher URL: `https://localhost/` (Uses Self-Signed Certificate)

Rancher Admin Username: `admin`

Rancher Admin Password: `REa24NI98s0kDUKV`

kube.config: `/Users/demo/.kube/config`

kube.config (Old One): `/Users/demo/.kube/config_old`

---

The k8s cluster is running on a single node (Rancher local cluster).

I recommend the following setup for a production environment:

- 1 Kubernetes cluster (At least 3 nodes) for the Rancher UI. (Please refer to https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade#high-availability-kubernetes-install-with-the-helm-cli)
- At least 3 Nodes as Master nodes (Uneven nodes help determinating the master-node)
- At least 3 Nodes for storage/longhorn (They should be in the same Datacenter as the worker-nodes for performance reasons)
- At least 3 Nodes as worker nodes.
- Some S3 storage to backup everything (Rancher, Longhorn and everything else.)

All nodes should be in the same Datacenter otherwise network I/O will be too slow.


# Demo Project
The repository of the project can be found at:
https://gitlab.com/AutoAwesome/demoproject/

# GitLab Docker Registry (To Pull Image from k8s)
Registry Domain: registry.gitlab.com

Username: `AutoAwesome` (Doesn't matter - Can be anything.)

Access Token: `glpat-dx3-J-GWO_o0d6UH02kBtmM6MQpvOjEKdTpseGI1Mw8.01.1715j8nkh`

Expires: `10. April 2026 + 4 Weeks`

```bash
demo@MacBook-Pro-von-Demo-2 demoproject % kubectl get -n app secrets    
NAME                          TYPE                             DATA   AGE
gitlab-registry-pull-secret   kubernetes.io/dockerconfigjson   1      42m
```

# Demo Project Deployed At:
https://localhost/api/v1/namespaces/app/services/http:sample-app:80/proxy/health

```
demo@MacBook-Pro-von-Demo-2 demoproject % kubectl get -n app deployments   
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
sample-app   1/1     1            1           113m
```

The deployment has healthchecks running which check /health to see if the app is running or not. 

## Demo Project CI

The complete CI of the demo project can be found at:
`https://gitlab.com/AutoAwesome/demoproject/-/blob/main/.gitlab-ci.yml`

This pipeline (gitlab-runner) builds the project and then pushes it to the (gitlab) docker-registry.
Since we are working on a local-cluster there is no way for gitlab-runner to connect to our server.
That's why I added another CI just for the staging. Usually I would not do that but let the gitlab-runner deploy the staging environment in commit.

Sadly even Rancher's Fleet CI/CD also requires a cluster. So I cannot use it either.
https://localhost/dashboard/c/_/fleet/application/fleet.cattle.io.gitrepo/fleet-default/sample-app-staging#bundles

I have also installed ArgoCD but had not enough time to figure it out.

ArgoCD URL: https://localhost/api/v1/namespaces/argocd/services/https:argocd-server:443/proxy/applications

ArgoCD Username: `admin`

ArgoCD Password: `z2tqcXnxan1RSyEO%`

### Just for the completeness - This would be my plan:
1. Create two namespaces (`app`, `app-staging`)
2. In namespace `app` deploy the app manually to publish it to release.
3. In namespace `app-staging` deploy the app automatically as test version. This can be done by any CI/CD. Just build -> test -> push to registry -> deploy build docker-image to k8s `app-staging`-namespace.
4. Add ingresses one public for the real-deployment. And the other one for the staging.


## Demo Project Testing
Usually the tests would run with the gitlab-ci pipeline. But since the project has no tests I'll skip this.

# Users / RBAC
The default `admin`-user can do anything.

Additional users can be created with either global permissions or per-project permissions. I always recommend per-project permissions. Global permissions are too far-reaching.

In rancher this is very easy to do through the 'Projects/Namespaces' UI.

https://localhost/dashboard/c/local/explorer/management.cattle.io.project/local/p-knrxg?mode=edit#members

If I have more time I would:
1. Create users for the Dev-Teams/Customers & restrict their permissions to what they are supposed to do. I.e. someone who deploys code does not need to see the secrets or the ability to create new namespaces. 
2. Make sure nobody can access/tamper with resources they are not allowed to.
3. By default only the admin can do everything. Permissions will give only when explicitly required or ordered by the lead.

For this app I would split like this:
- **Admins** can do anything in both Projects (Sample-App and Sample-App Staging). Admins can not create new projects (but namespaces within the projects)
- **Operators** can create/tamper/delete deployments/services within both Projects (Sample-App and Sample-App Staging). They cannot create additional namespaces. But they can create services/deployments.
- **Developers** can only modify resources ONLY in the Staging namespace
- **Deployer** can only redeploy the app which on purpose has the image "...:latest" with the pull policy "Always" which forces k8s to always pull the newest image on redeploy. The deployer role is exclusively used by CI/CD (gitlab-ci/runner or anything else really.)
- **Viewer** is a pure readonly rule. Can read any resources within the two projects.

*FYI: Projects in Rancher groups multiple namespaces and are otherwise isolated from each other.*

# Network Isolation
For proper network isolation Rancher requires a real k8s cluster (not a local one.).
With a real k8s cluster it is very easy to enable network-isolation on project base or just with regular yaml files. Additionally rancher cannot do network isolation when running on k3s clusters. Since the local cluster uses k3s I have not implemented it yet.

See the bugreport yourself: https://github.com/rancher/rancher/issues/36007

However - ranchers default policy is to deny all comminucation:
https://localhost/dashboard/c/local/explorer/networking.k8s.io.networkpolicy




