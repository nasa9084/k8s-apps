Kubernetes-apps
---------------

Application definitions running on web-apps.tech

## USAGE

use [kustomize](https://github.com/kubernetes-sigs/kustomize).

e.g.: `$ kustomize build` for checking and deploy with `$ kustomize build | kubectl apply -f-`

### required secrets

* `alertmanager-slack-url`
  * key: `alertmanager_slack_url`
  * value: slack incoming webhook url to use alerting
* `growi-password-seed`
  * key: `seed`
  * value: any string
* `hackmd-db-password`
  * key: `postgres-password`
  * value: password for postgresql
* `redmine-postgres-password`
  * key: `password`
  * value: password for postgresql
