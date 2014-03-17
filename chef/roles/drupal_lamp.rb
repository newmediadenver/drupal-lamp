name 'drupal_lamp'
description 'A LAMP server designed to run Drupal.'

default_attributes(
  'authorization' => {
    'sudo' => {
      'sudoers_defaults' => [
        'env_reset',
        'exempt_group=admin',
        "secure_path='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'",
      ],
      'agent_forwarding' => true,
      'groups' => ['admin', 'sudo'],
      'passwordless' => true
    }
  },
 'apache' => {
    'prefork' => {
      'startservers' => '1',
      'minspareservers' => '1',
      'maxspareservers' => '2',
      'maxclients' => '15',
      'serverlimit' => '15',
      'keepalive' => 'On',
      'keepalivetimeout' => '4',
      'maxkeepaliverequests' => '1000'
    }
  },
  'build_essential' => {
    'compiletime' => true
  },
  'db' => {
    'driver' => 'mysql',
    'client_recipe' => 'mysql::client',
    'root' => 'root',
    'grant_hosts' => [
      'localhost'
    ],
    'users' => {
      'root' => 'root',
      'replication' => 'replication',
      'debian' => 'debian'
    }
  },
  'mysql' => {
    'server_debian_password' => 'debian',
    'server_root_password' => 'root',
    'server_repl_password' => 'replication',
    'allow_remote_root' => 'true',
    'tunable' => {
      'max_allowed_packet' => '16M',
      'key_buffer_size' => '32M',
      'max_connect_errors' => '1000',
      'tmp_table_size' => '32M',
      'max_connections' => '500',
      'thread_cache_size' => '50',
      'table_open_cache' => '512',
      'innodb_flush_log_at_trx_commit' => '0',
      'innodb_file_per_table' => '1',
      'innodb_buffer_pool_size' => '128M',
      'innodb_flush_method' => 'O_DIRECT',
      'sync_binlog' => '0'
    }
  },
  'php' => {
    'directives' => {
      'memory_limit' => '1024M',
      'upload_max_filesize' => '200M',
      'post_max_size' => '210M'
    },
    'conf_dir' => '/etc/php5/apache2'
  }
)

env_run_lists '_default' => [
                'recipe[apt]',
                'recipe[build-essential]',
                'recipe[drupal::init]',
                'recipe[sudo]',
                'recipe[git]',
                'recipe[mysql::server]',
                'recipe[drupal::ssh]',
                'recipe[drupal::apache]',
                'recipe[drupal::php]',
                'recipe[drupal::drush]',
                'recipe[drupal::mysql]',
                'recipe[drupal]',
              ]
