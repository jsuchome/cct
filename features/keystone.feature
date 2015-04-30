@keystone
Feature: Keystone
  As an administrator
  I want to make sure the Keystone component is configured and running
  In order to provide authentification and authorization service to  other Openstack components

  Scenario: User create # was test no.30
    Given I have a tenant named 'openstack'
    When I can delete a user named 'test_user'
    Then I can create a new user named 'test_user'

  Scenario: User Login # was test no.40
    Given I have a test_user
    Then I can ask Nova for information about the test_user

