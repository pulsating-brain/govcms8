<?php /** @noinspection PhpUndefinedNamespaceInspection */

/**
 * @file
 * Drupal site-specific configuration file.
 *
 * Note that if you are installing on a non-standard port number, prefix the
 * hostname with that number. For example,
 * https://www.drupal.org:8080/mysite/test/ could be loaded from
 * sites/8080.www.drupal.org.mysite.test/.
 *
 * @see example.sites.php
 * @see \Drupal\Core\DrupalKernel::getSitePath()
 *
 * In addition to customizing application settings through variables in
 * settings.php, you can create a services.yml file in the same directory to
 * register custom, site-specific service definitions and/or swap out default
 * implementations with custom ones.
 */

/**
 * Database settings:
 */

$databases['default']['default'] = array (
  'database' => 'drupal',
  'username' => 'drupal',
  # TODO secure this
  'password' => 'my-secret-password',
  'prefix' => '',
  'host' => 'db',
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
  'collation' => 'utf8mb4_general_ci'
);



/**
 * Location of the site configuration files.
 *
 * The $config_directories array specifies the location of file system
 * directories used for configuration db-data. On install, the "sync" directory is
 * created. This is used for configuration imports. The "active" directory is
 * not created by default since the default storage for active configuration is
 * the database rather than the file system. (This can be changed. See "Active
 * configuration settings" below).
 *
 * The default location for the "sync" directory is inside a randomly-named
 * directory in the public files path. The setting below allows you to override
 * the "sync" location.
 *
 * If you use files for the "active" configuration, you can tell the
 * Configuration system where this directory is located by adding an entry with
 * array key CONFIG_ACTIVE_DIRECTORY.
 */
$config_directories = array(
  /**
   * CONFIG_SYNC_DIRECTORY => '/directory/outside/webroot',
   */
);

/**
 * Site-specific settings:
 */

/**
 * Salt for one-time login links, cancel links, form tokens, etc.
 * For enhanced security, you may set this variable to the contents of a file
 * outside your document root; you should also ensure that this file is not
 * stored with backups of your database.
 * TODO make this salt private and random
 */
$settings['hash_salt'] = 'bPFNSJ0xxxqpXj51AyYXJLp4lQq0g8lUgCf92BYQ_jYBeT681JF7pT7K792Oa_pXxX9Df5BETw';

/**
 * Disable access to the update.php script.
 */
$settings['update_free_access'] = FALSE;

/**
 * Disable website code updates through Drupal's Update Manager module - we
 * build production images and sequentially roll them out after testing
 */
$settings['allow_authorize_operations'] = FALSE;

/**
 * Public file path:
 *
 * A local file system path where public files will be stored. This directory
 * must exist and be writable by Drupal. This directory must be relative to
 * the Drupal installation directory and be accessible over the web.
 */
$settings['file_public_path'] = 'sites/default/files';

/**
 * Private file path:
 *
 * A local file system path where private files will be stored. This directory
 * must be absolute, outside of the Drupal installation directory and not
 * accessible over the web.
 *
 * Note: Caches need to be cleared when this value is changed to make the
 * private:// stream wrapper available to the system.
 *
 * See https://www.drupal.org/documentation/modules/file for more information
 * about securing private files.
 */
$settings['file_private_path'] = '/var/www/private';

/**
 * Active configuration settings.
 *
 * By default, the active configuration is stored in the database in the
 * {config} table. To use a different storage mechanism for the active
 * configuration, do the following prior to installing:
 * - Create an "active" directory and declare its path in $config_directories
 *   as explained under the 'Location of the site configuration files' section
 *   above in this file. To enhance security, you can declare a path that is
 *   outside your document root.
 * - Override the 'bootstrap_config_storage' setting here. It must be set to a
 *   callable that returns an object that implements
 *   \Drupal\Core\Config\StorageInterface.
 * - Override the service definition 'config.storage.active'. Put this
 *   override in a services.yml file in the same directory as settings.php
 *   (definitions in this file will override service definition defaults).
 */
# TODO configure config file storage
# $settings['bootstrap_config_storage'] = array('Drupal\Core\Config\BootstrapConfigStorageFactory', 'getFileStorage');

/**
 * Configuration overrides.
 *
 * To globally override specific configuration values for this site,
 * set them here. You usually don't need to use this feature. This is
 * useful in a configuration file for a vhost or directory, rather than
 * the default settings.php.
 *
 * Note that any values you provide in these variable overrides will not be
 * viewable from the Drupal administration interface. The administration
 * interface displays the values stored in configuration so that you can stage
 * changes to other environments that don't have the overrides.
 *
 * There are particular configuration values that are risky to override. For
 * example, overriding the list of installed modules in 'core.extension' is not
 * supported as module install or uninstall has not occurred. Other examples
 * include field storage configuration, because it has effects on database
 * structure, and 'core.menu.static_menu_link_overrides' since this is cached in
 * a way that is not config override aware. Also, note that changing
 * configuration values in settings.php will not fire any of the configuration
 * change events.
 */
# $config['system.file']['path']['temporary'] = '/tmp';
# $config['system.site']['name'] = 'My Drupal site';
# $config['system.theme']['default'] = 'stark';
# $config['user.settings']['anonymous'] = 'Visitor';

/**
 * Load services definition file.
 */
/** @noinspection PhpUndefinedVariableInspection */
/** @noinspection PhpUndefinedVariableInspection */
$settings['container_yamls'][] = $app_root . '/' . $site_path . '/services.yml';

/**
 * Trusted host configuration.
 *
 * Drupal core can use the Symfony trusted host mechanism to prevent HTTP Host
 * header spoofing.
 *
 * To enable the trusted host mechanism, you enable your allowable hosts
 * in $settings['trusted_host_patterns']. This should be an array of regular
 * expression patterns, without delimiters, representing the hosts you would
 * like to allow.
 *
 * For example:
 * @code
 * $settings['trusted_host_patterns'] = array(
 *   '^www\.example\.com$',
 * );
 * @endcode
 * will allow the site to only run from www.example.com.
 *
 * If you are running multisite, or if you are running your site from
 * different domain names (eg, you don't redirect http://www.example.com to
 * http://example.com), you should specify all of the host patterns that are
 * allowed by your site.
 *
 * For example:
 * TODO configure trusted hosts
 * @code
 * $settings['trusted_host_patterns'] = array(
 *   '^example\.com$',
 *   '^.+\.example\.com$',
 *   '^example\.org$',
 *   '^.+\.example\.org$',
 * );
 * @endcode
 * will allow the site to run off of all variants of example.com and
 * example.org, with all subdomains included.
 */

/**
 * The default list of directories that will be ignored by Drupal's file API.
 */
$settings['file_scan_ignore_directories'] = [
  'node_modules',
  'bower_components',
];

/**
 * The default number of entities to update in a batch process.
 */
$settings['entity_update_batch_size'] = 50;

/**
 * Load local development override configuration, if available.
 *
 * Use settings.local.php to override variables on secondary (staging,
 * development, etc) installations of this site. Typically used to disable
 * caching, JavaScript/CSS compression, re-routing of outgoing emails, and
 * other things that should not happen on development and testing sites.
 *
 * Keep this code block at the end of this file to take full effect.
 */
#
# if (file_exists($app_root . '/' . $site_path . '/settings.local.php')) {
#   include $app_root . '/' . $site_path . '/settings.local.php';
# }

$settings['install_profile'] = 'govcms';
$config_directories['sync'] = 'sites/default/files/config_Mwu8sF24q_iBxjNZVTTRqYziwMc3js0dGtmxLYM57QjRHBEcWvEDwLniaXzEzw5_EyEM5pvJkA/sync';
