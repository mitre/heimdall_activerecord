# LDAP Integration

LDAP integration is controlled by a LDAP.yml file which will be located in the /HEIMDALLDIR/config folder. There should be a file called ldap.example.yml, go ahead and copy this and rename it to ldap.yml.

## Example of ldap.example.yml

```
# You can also just copy and paste the tree (do not include the "authorizations") to each
# environment if you need something different per environment.
authorizations: &AUTHORIZATIONS
  allow_unauthenticated_bind: false
  group_base: ou=groups,dc=test,dc=com
  ## Requires config.ldap_check_group_membership in devise.rb be true
  # Can have multiple values, must match all to be authorized
  required_groups:
    # If only a group name is given, membership will be checked against "uniqueMember"
    - cn=admins,ou=groups,dc=test,dc=com
    - cn=users,ou=groups,dc=test,dc=com
    # If an array is given, the first element will be the attribute to check against, the second the group name
    - ["moreMembers", "cn=users,ou=groups,dc=test,dc=com"]
  ## Requires config.ldap_check_attributes in devise.rb to be true
  ## Can have multiple attributes and values, must match all to be authorized
  require_attribute:
    objectClass: inetOrgPerson
    authorizationRole: postsAdmin
  ## Requires config.ldap_check_attributes_presence in devise.rb to be true
  ## Can have multiple attributes set to true or false to check presence, all must match all to be authorized
  require_attribute_presence:
    mail: true
    telephoneNumber: true
    serviceAccount: false

## Environment

development:
  host: host.yourdomain.com
  port: 636
  attribute: mail
  base: ou=People,o=yourdomain.com
  admin_user: cn=admin,dc=test,dc=com
  admin_password: "credentials"
  ssl: true
  # <<: *AUTHORIZATIONS

test:
  host: localhost
  port: 3389
  attribute: cn
  base: ou=people,dc=test,dc=com
  admin_user: cn=admin,dc=test,dc=com
  admin_password: "credentials"
  ssl: simple_tls
  # <<: *AUTHORIZATIONS

production:
  host: host.yourdomain.com
  port: 636
  attribute: mail
  base: ou=People,o=yourdomain.com
  admin_user: cn=admin,dc=test,dc=com
  admin_password: "credentials"
  ssl: true
  # <<: *AUTHORIZATIONS
```

These values will need to be changed to reflect the LDAP server you are connecting to. Your LDAP admin or IT specialist should be able to provide you with the necessary information.

## Devise.rb Configuration

This file is located at /heimdall/config/initializers/devise.rb

```



```