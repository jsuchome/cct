@glance
Feature: Glance
  As an administrator
  I want to make sure that Glance component component working correctly

  @create_image
  Scenario: Image create (was test #107)
    Given Glance is prepared for testing and testing image exists
    When I create new glance image based on jeos1
    Then the image is listed as active
    And this image can be shown by its ID
