data "http" "vnet1" {
    url = "https://www.dot.com" // or https://${var.web}/${var.folder}
    request_headers = {
        Accept = "application/json"
    }
}

locals {
    vnetdata = jsonencode(data.http.vnet.body)
}