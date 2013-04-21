name "drupal_lamp"
description "A LAMP server designed to run Drupal."

env_run_lists "_default" => [
                "recipe[apache2]",
                "recipe[php]",
              ]
