name "drupal_lamp"
description "A LAMP server designed to run Drupal."

default_attributes(
  'authorization' => {
    'sudo' => {
      'sudoers_defaults' => [
        'env_reset',
        'exempt_group=admin',
        'secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"',
      ],
      'agent_forwarding' => true,
      "groups" => ["admin", "sudo"],
      "passwordless" => true
    }
  }
)
env_run_lists "_default" => [
                "recipe[sudo]",
                "recipe[git]",
                "recipe[drupal::apache]",
                "recipe[drupal::php]",
                "recipe[drupal::drush]",
                "recipe[drupal::mysql]",
                "recipe[drupal]",
              ]
