data "aws_canonical_user_id" "current" {}

resource "aws_s3_bucket_acl" "internal_alb_bucket" {
  bucket = var.alb_internal_s3_bucket_id
  access_control_policy {
    grant {
      grantee {
        id   = data.aws_canonical_user_id.current.id
        type = "CanonicalUser"
      }
      permission = "READ_ACP"
    }

    grant {
      grantee {
        id   = data.aws_canonical_user_id.current.id
        type = "CanonicalUser"
      }
      permission = "WRITE_ACP"
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}
