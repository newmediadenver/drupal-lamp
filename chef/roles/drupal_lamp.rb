name 'drupal_lamp'
description 'A LAMP server designed to run Drupal.'

default_attributes(
  'authorization' => {
    'sudo' => {
      'sudoers_defaults' => [
        'env_reset',
        'exempt_group=admin',
        'secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"',
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
      'maxspareservers' => '5',
      'maxclients' => '6',
      'serverlimit' => '6',
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
      'sync_binlog' => '0',
      'innodb_flush_log_at_trx_commit' => '0',
      'max_allowed_packet' => '16M',
      'max_connect_errors' => '1000000',
      'tmp_table_size' => '32M',
      'max_heap_table_size' => '32M',
      'query_cache_type' => '0',
      'max_connections' => '500',
      'thread_cache_size' => '50',
      'open_files_limit' => '65535',
      'table_definition_cache' => '4096',
      'table_open_cache' => '4096',
      'innodb_flush_method' => 'O_DIRECT',
      'innodb_file_per_table' => '1',
      'innodb_buffer_pool_size' => '128M',
      'query_cache_size' => '12M',
      'table_cache' => '5120'
    }
  },
  'php' => {
    'directives' => {
      'memory_limit' => '192M',
      'upload_max_filesize' => '8M',
      'post_max_size' => '10M'
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
