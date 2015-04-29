@glance
Feature: Glance
  As an administrator
  I want to make sure that Glance component is working correctly

  @create_kvm_image
  Scenario: Creation of KVM image (was test #107)
    Given Glance is prepared for testing and KVM source image exists
    And glance image does not exist
    When I create new glance image based on jeos1
    Then the image is listed as active
    And this image has non-empty ID
    And its ID can be used to show the image info
    When I delete the image
    Then it is no longer listed

  @create_xen_hvm_image
  Scenario: Creation of XEN HVM image (was test #108)
    Given Glance is prepared for testing and XEN HVM source image exists
    And glance image does not exist
    When I create new glance image based on jeos1
    Then the image is listed as active
    And this image has non-empty ID
    And its ID can be used to show the image info
    When I delete the image
    Then it is no longer listed

  @create_xen_pv_image
  Scenario: Creation of XEN PV image (was test #109)
    Given Glance is prepared for testing and XEN PV source image exists
    And glance image does not exist
    When I create new glance image based on jeos1
    Then the image is listed as active
    And this image has non-empty ID
    And its ID can be used to show the image info
    When I delete the image
    Then it is no longer listed


