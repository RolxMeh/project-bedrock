resource "helm_release" "ui" {
  name      = "ui"
  namespace = "retail-app"
  chart     = "${path.module}/../../retail-store-sample-app/src/ui/chart"

  create_namespace = true

  set = [
    {
      name  = "ingress.enabled"
      value = "true"
    },
    {
      name  = "ingress.className"
      value = "alb"
    },
    {
      name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
      value = "internet-facing"
    },
    {
      name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/target-type"
      value = "ip"
    }
  ]

  depends_on = [
    helm_release.aws_load_balancer_controller
  ]
}