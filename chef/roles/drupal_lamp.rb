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
  },
  'mysql' => {
    'server_debian_password' => 'debian',
    'server_root_password' => 'root',
    'server_repl_password' => 'replication'
  }
)

env_run_lists "_default" => [
                "recipe[drupal::init]",
                "recipe[sudo]",
                "recipe[git]",
                "recipe[build-essential]",
                "recipe[mysql::server]",
                "recipe[drupal::ssh]",
                "recipe[drupal::apache]",
                "recipe[drupal::php]",
                "recipe[drupal::drush]",
                "recipe[drupal::mysql]",
                "recipe[drupal]",
              ]
