@keystone
Feature: Keystone
  As an administrator
  I want to make sure the Keystone component is configured and running
  In order to provide authentification and authorization service to  other Openstack components

  Scenario: User create # was test no.30
    Given I have a tenant named 'openstack'
    And there is no user named 'test_user'
    When I add a new user named 'test_user' to the tenant
    Then this new user is known by Keystone
    And this new user is member of that tenant

  Scenario: User Login # was test no.40
    Given I have a keystone userid
    When I list all users known to Nova
    Then my username is part of that list

