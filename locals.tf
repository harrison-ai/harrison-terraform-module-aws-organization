locals {

  top_level_org_unit_attributes = [
    for ou in var.top_level_org_units :
    {
      name   = ou.name
      uuid   = ou.uuid
      id     = aws_organizations_organizational_unit.top_level_org_units[ou.uuid].id
      parent = aws_organizations_organizational_unit.top_level_org_units[ou.uuid].parent_id
    }
  ]

  child_org_unit_attributes = [
    for ou in var.child_org_units :
    {
      name   = ou.name
      uuid   = ou.uuid
      id     = aws_organizations_organizational_unit.child_org_units[ou.uuid].id
      parent = aws_organizations_organizational_unit.child_org_units[ou.uuid].parent_id
    }
  ]

  org_units = concat(local.top_level_org_unit_attributes, local.child_org_unit_attributes)

  top_level_scp_attachments = flatten([
    for ou in var.top_level_org_units : [
      for scp in ou.attached_scps : {
        ou_name = ou.name
        ou_uuid = ou.uuid
        ou_id   = aws_organizations_organizational_unit.top_level_org_units[ou.uuid].id
        scp     = scp
      }
    ] if ou.attached_scps != []
  ])

  child_scp_attachments = flatten([
    for ou in var.child_org_units : [
      for scp in ou.attached_scps : {
        ou_name = ou.name
        ou_uuid = ou.uuid
        ou_id   = aws_organizations_organizational_unit.child_org_units[ou.uuid].id
        scp     = scp
      }
    ] if ou.attached_scps != []
  ])

  scp_attachments = concat(local.top_level_scp_attachments, local.child_scp_attachments)

}
