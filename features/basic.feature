Feature: Check SQS queue size

  Background:

    Given a file "accounts.xml":
      """
      <aws-accounts>
        <aws-account
          name="account"
          access-key-id="access key id"
          secret-access-key="secret access key"/>
      </aws-accounts>
      """

    Given a file "default.args":
      """
      --config accounts.xml
      --account account
      --queue-name queue
      --warning 1
      --critical 2
      """

  Scenario: Ok

    Given the queue has 0 items

    When I invoke hq-aws-check-sqs-queue with "default.args"

    Then the command stdout should be:
      """
      SQS queue OK: 0 messages
      """
    And the command exit status should be 0

  Scenario: Warning

    Given the queue has 1 items

    When I invoke hq-aws-check-sqs-queue with "default.args"

    Then the command stdout should be:
      """
      SQS queue WARNING: 1 messages (warning is 1)
      """
    And the command exit status should be 1

  Scenario: Critical

    Given the queue has 2 items

    When I invoke hq-aws-check-sqs-queue with "default.args"

    Then the command stdout should be:
      """
      SQS queue CRITICAL: 2 messages (critical is 2)
      """
    And the command exit status should be 2
