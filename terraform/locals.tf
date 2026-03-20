locals {
  myip = "${trimspace(data.http.mypublicIP.response_body)}/32"
}