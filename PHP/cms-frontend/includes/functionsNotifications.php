<?php

// $notificationsArray = array("you have been notified" => "green","notification #2" => "green","stop doing that!" => "red","im serious" => "green");

function notifications () {
	echo '<!-- notifications -->'."\n";
	echo '<section id="notificationsContainer" class="mainContent">'."\n";
	echo "\t".'<ul>'."\n";
	foreach (array_keys($GLOBALS['notificationsArray']) as $notification) {
		if ($GLOBALS['notificationsArray'][$notification] == 'red') {
			echo "\t\t".'<li class="red">';
		} elseif ($GLOBALS['notificationsArray'][$notification] == 'green') {
			echo "\t\t".'<li class="green">';
		} else {
			echo "\t\t".'<li>';
		}
		echo $notification;
		echo '</li>'."\n";
	}
	echo "\t".'</ul>'."\n";
	echo '</section>'."\n";
}

?>