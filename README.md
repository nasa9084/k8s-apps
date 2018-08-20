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
