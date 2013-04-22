name "drupal_lamp"
description "A LAMP server designed to run Drupal."

env_run_lists "_default" => [
                "recipe[git]",
                "recipe[drupal::apache]",
                "recipe[drupal::php]",
                "recipe[drupal::drush]",
                "recipe[drupal::mysql]",
                "recipe[drupal]",
              ]
