Terraform / Kubernetes
1. Create a managed kubernetes (and LB) cluster trough Terraform.
This can be a very small cluster using only 1 relatively small node. You can do this on any cloud platform. We often use digitalocean, they also give you 100$ in credits for free:(https://try.digitalocean.com/developerbrand/). That should be plenty for the duration of this assignment.

2. Deploy 2 applications on the cluster (with templates)
- Single node Elasticsearch instance
- Super small Node.js API returning ES cluster status (with ES connection details as ENV variables), built as a docker container.

For this step we can provide you with a Docker Hub Registry if needed. Although also I believe on personal accounts you can get one for free.

3. Use any Ingress Controller for directing traffic from 2 different domain names (if you want we can add 2 for you on our domain) to the 2 different apps that you have deployed in the cluster.

VM / Ansible 
1. "Dockerize" this application (it's not ours ;)): https://github.com/jason-michael/express-mysql-todo

2. Create an ansible playbook that sets up the basics for a linux VM (distro of your choice) and everything you need to run docker containers.

3. Add to the playbook a role to run on the VM 2 containers, exposing only the web app to the public. Next to that of course everything required to see the app working!
- Mysql (5.7 is probably easiest for this app due to auth methods in mysql) 
- Your own dockerized TODO application

4. Bonus: Setup HTTPS trough let's encrypt for accessing the app on a domain trough a reverse proxy running in an additional container. We can create the dns record for you if you don't have access to a domain.