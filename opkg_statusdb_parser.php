<?php 
# by DSR! from https://github.com/xchwarze/wifi-pineapple-cloner

error_reporting(E_ALL);

if (!isset($_SERVER['argv']) && !isset($argv)) {
    echo "Please enable the register_argc_argv directive in your php.ini\n";
    exit(1);
} elseif (!isset($argv)) {
    $argv = $_SERVER['argv'];
}

if (!isset($argv[1])) {
    echo "Argument expected: path to opkg status file\n";
    exit(1);
}

function processFile($fileName, $showEssentials)
{
	$block = [];
	$output = [];

	foreach (file($fileName) as $line) {
		$clean = trim($line);

		if (empty($clean)) {
			if (count($block) > 0) {
				$output[] = $block;
				$block = [];
			}
		} else {
			$parts = explode(': ', $clean);
			if (count($parts) == 2) {
				$block[ trim($parts[0]) ] = trim($parts[1]);	
			}
		}
	}

	// esto no tendia que pasar nunca porque el status file viene con varios saltos de linea al final
	if (count($block) > 0) {
		$output[] = $block;		
	}

	return cleanInstallData($output, $showEssentials);
}

function cleanInstallData($output, $showEssentials)
{
	$final = [];
	foreach ($output as $data) {
		if ( 
			!isset($data['Auto-Installed']) && 
			isValidPackage($data['Package']) 
		) {
			if (
				!isset($data['Essential']) || 
				(
					isset($data['Essential']) && $showEssentials
				)
			) {
				$final[] = $data['Package'];
			}
		}
	}

	sort($final);
	return $final;
}

function isValidPackage($name)
{
	// hak5 packages (based on mk6)
	$packageBlacklist = [
		'pineap',
		'aircrack-ng-hak5',
		'cc-client',
		'libwifi',
		'resetssids',
		'http_sniffer',
		'log_daemon',
	];

	// only kmod
	//return !in_array($name, $packageBlacklist) && strpos($name, 'kmod-') !== false;

	// not show kmod
	//return !in_array($name, $packageBlacklist) && strpos($name, 'kmod-') === false;

	// all
	return !in_array($name, $packageBlacklist);
}


// from /usr/lib/opkg/status
$statusFile = $argv[1];
$statusData = processFile($statusFile, false);

echo "======== Packages ========\n";
echo "Total: " . count($statusData) . "\n";
echo implode(' ', $statusData);

$statusDataEssentials = processFile($statusFile, true);
$essentialPackages = [];
foreach ($statusDataEssentials as $key) {
	if (!in_array($key, $statusData)) {
		$essentialPackages[] = $key;
	}
}

echo "\n\n\n\n";
echo "======== Essentials Packages ========\n";
echo "Total: " . count($essentialPackages) . "\n";
echo implode(' ', $essentialPackages);
