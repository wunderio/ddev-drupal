<?php

namespace Wunderio\DdevDrupal\Composer;

use Composer\Composer;
use Composer\EventDispatcher\EventSubscriberInterface;
use Composer\Installer\PackageEvent;
use Composer\Installer\PackageEvents;
use Composer\IO\IOInterface;
use Composer\Plugin\PluginInterface;

/**
 * Class InstallHelperPlugin.
 *
 * Help to deploy files to project root and install custom extensions.
 *
 * @package Wunderio\DdevDrupal\Composer
 */
class InstallHelperPlugin implements PluginInterface, EventSubscriberInterface {

  /**
   * Name of this package.
   */
  private const PACKAGE_NAME = 'wunderio/ddev-drupal';

  /**
   * The Composer service.
   *
   * @var \Composer\Composer
   */
  protected $composer;

  /**
   * Composer's I/O service.
   *
   * @var \Composer\IO\IOInterface
   */
  protected $io;

  /**
   * Full path to project root where composer.json is located.
   *
   * Example: /app.
   *
   * @var string
   */
  protected $projectDir;

  /**
   * Full path to the vendor directory.
   *
   * Example: /app/vendor.
   *
   * @var string
   */
  protected $vendorDir;

  /**
   * {@inheritdoc}
   */
  public function activate(Composer $composer, IOInterface $io): void {
    $this->composer = $composer;
    $this->io = $io;
    $this->projectDir = getcwd();

    $vendor_dir = $this->composer->getConfig()->get('vendor-dir');
    $this->vendorDir = realpath($vendor_dir);
  }

  /**
   * {@inheritdoc}
   */
  public static function getSubscribedEvents() {
    return [
      PackageEvents::POST_PACKAGE_INSTALL => [
        ['onWunderIoDdevDrupalPackageInstall', 0],
      ],
      PackageEvents::POST_PACKAGE_UPDATE => [
        ['onWunderIoDdevDrupalPackageInstall', 0],
      ],
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function deactivate(Composer $composer, IOInterface $io) {

  }

  /**
   * {@inheritdoc}
   */
  public function uninstall(Composer $composer, IOInterface $io) {
  }

  /**
   * Install event callback called from getSubscribedEvents().
   *
   * @param \Composer\Installer\PackageEvent $event
   *   Composer package event sent on install/update/remove.
   */
  public function onWunderIoDdevDrupalPackageInstall(PackageEvent $event) {
    /** @var \Composer\DependencyResolver\Operation\InstallOperation $operation */
    $operation = $event->getOperation();

    // Composer operations have access to packages, just through different
    // methods, which depend on whether the operation is an InstallOperation or
    // an UpdateOperation
    $current_package = method_exists($operation, 'getPackage')
      ? $operation->getPackage()
      : $operation->getInitialPackage();

    $current_package_name = $current_package->getName();

    // We only want to continue for this package.
    if ($current_package_name !== self::PACKAGE_NAME) {
      return NULL;
    }

    self::deployDdevFiles();

    // Run the update-grumphp-command.php script.
    $output = shell_exec('bash vendor/wunderio/ddev-drupal/scripts/update-grumphp-command.sh');
    $this->io->write("<info>{$output}</info>");
  }

  /**
   * Update event callback called from getSubscribedEvents().
   *
   * @param \Composer\Installer\PackageEvent $event
   *   Composer package event sent on install/update/remove.
   */
  public function onWunderIoDdevDrupalPackageUpdate(PackageEvent $event) {
    self::deployDdevFiles();
  }

  /**
   * Copy the config.wunderio.yaml file and the dist/ directory contents to the project.
   */
  private function deployDdevFiles(): void {
    $dest_dir = "{$this->projectDir}";

    // Clean up old files from project root so we can deploy file removal.
    // This is not ideal solution as we need to keep track of files to delete -
    // basically this should cover everything that is in the dist/ directory.
    $paths_to_delete = [
      '.ddev/config.wunderio.yaml',
      '.ddev/commands/web/wunderio-core-*',
      '.ddev/wunderio/core/',
      '.ddev/wunderio/custom/.gitignore',
      'drush/sites/local.site.yml',
    ];
    foreach($paths_to_delete as $path) {
      $full_delete_path = "{$dest_dir}/$path";

      if (is_file($full_delete_path)) {
        unlink($full_delete_path);
      }
      elseif (is_dir($full_delete_path)) {
        self::rDelete($full_delete_path);
      }
      elseif (strpos($full_delete_path, '*') !== FALSE) {
        $files = glob($full_delete_path);
        foreach($files as $file){
          if(is_file($file)){
            unlink($file);
          }
        }
      }
      else{
        $this->io->write("The path is neither a file nor a directory. Can't delete: {$full_delete_path}");
      }
    }

    // Copy contents of dist folder to project.
    $dist_dir = "{$this->vendorDir}/" . self::PACKAGE_NAME . '/dist';
    self::rcopy($dist_dir, $dest_dir);
  }

  /**
   * Recursively delete a directory and its contents.
   *
   * @param string $dir
   *   Directory to be deleted.
   *
   * @return bool
   *   TRUE if directory deletion was successful, FALSE otherwise.
   */
  private static function rDelete($dir): bool {
    if (!is_dir($dir)) {
      echo "Directory does not exist";
      return FALSE;
    }

    $files = array_diff(scandir($dir), array('.', '..'));

    foreach ($files as $file) {
      $path = $dir . '/' . $file;

      if (is_dir($path)) {
        self::rDelete($path);
      }
      else {
        unlink($path);
      }
    }

    return rmdir($dir);
  }

  /**
   * Recursively copy files from one directory to another.
   *
   * Code is borrowed from koodimonni/composer-dropin-installer.
   *
   * @param string $src
   *   Source of files being copied.
   * @param string $dest
   *   Destination of files being copied.
   *
   * @return bool
   *   TRUE if recursive copy was successful, FALSE otherwise.
   */
  private static function rcopy($src, $dest): bool {
    // If source is not a directory stop processing.
    if (!is_dir($src)) {
      echo "Source is not a directory";
      return FALSE;
    }

    // If the destination directory does not exist create it.
    if (!is_dir($dest)) {
      if (!mkdir($dest, 0777, TRUE)) {
        // If the destination directory could not be created stop processing.
        echo "Can't create destination path: {$dest}\n";
        return FALSE;
      }
    }

    // Open the source directory to read in files.
    $i = new \DirectoryIterator($src);
    foreach ($i as $f) {
      if ($f->isFile()) {
        umask(0);
        copy($f->getRealPath(), "$dest/" . $f->getFilename());
        // Add execute permission to script file.
        if (pathinfo($f->getFilename(), PATHINFO_EXTENSION) === 'sh') {
          chmod("$dest/" . $f->getFilename(), 0755);
        }
      }
      elseif (!$f->isDot() && $f->isDir()) {
        self::rcopy($f->getRealPath(), "$dest/$f");
        // unlink($f->getRealPath());
      }
    }

    return TRUE;
    // We could Remove original directories but don't do it
    // unlink($src);
  }

  /**
   * Copy a file from one location to another.
   *
   * Code is borrowed from koodimonni/composer-dropin-installer.
   *
   * @param string $src
   *   File being copied.
   * @param string $dest
   *   Destination directory.
   *
   * @return bool
   *   TRUE if copy was successful, FALSE otherwise.
   */
  private static function copy(string $src, string $dest): bool {
    // If the destination directory does not exist create it.
    if (!is_dir($dest)) {
      if (!mkdir($dest, 0777, TRUE)) {
        // If the destination directory could not be created stop processing.
        echo "Can't create destination path: {$dest}\n";
        return FALSE;
      }
    }
    copy($src, "$dest/" . basename($src));

    return TRUE;
  }

}
