##########################################################################################
# DBL accounts
connection "dreambox" {
  plugin  = "aws"
  profile = "FederatedAdmin"
  regions = ["us-east-1", "us-west-2"]
}

connection "dbl_dev" {
  plugin  = "aws"
  profile = "dbl-dev-sre"
  regions = ["us-east-1", "us-west-2"]
}

connection "dbl_prod" {
  plugin  = "aws"
  profile = "dbl-prod-sre"
  regions = ["us-east-1", "us-west-2"]
}

connection "rp_dev" {
  plugin  = "aws"
  profile = "dbl-rpdev-sre"
  regions = ["us-east-1", "us-west-2"]
}

connection "rp_prod" {
  plugin  = "aws"
  profile = "dbl-rpprod-sre"
  regions = ["us-east-1", "us-west-2"]
}

connection "dbl_security" {
  plugin  = "aws"
  profile = "dbl-security-sre"
  regions = ["us-east-1", "us-west-2"]
}

connection "dbl_shared" {
  plugin  = "aws"
  profile = "dbl-shared-sre"
  regions = ["us-east-1", "us-west-2"]
}

connection "dbl_stage" {
  plugin  = "aws"
  profile = "dbl-stage-sre"
  regions = ["us-east-1", "us-west-2"]
}

connection "dbl_website" {
  plugin  = "aws"
  profile = "dbl-website-sre"
  regions = ["us-east-1", "us-west-2"]
}

connection "dbl_sre" {
  plugin  = "aws"
  profile = "dbl-sre-sre"
  regions = ["us-east-1", "us-west-2"]
}


##########################################################################################
# Aggregate connections
connection "dbl_all" {
  plugin      = "aws"
  type        = "aggregator"
  connections = [
    "dbl_dev",
    "dbl_prod",
    "dbl_shared",
    "dbl_stage",
    "dbl_sre",

    "dbl_security",
    "dbl_website",
    "rp_dev",
    "rp_prod",

    "dreambox"
  ]
}