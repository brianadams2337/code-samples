<?php

/* ENTER THE AREAS OF SUBNAV, separated by commas, ALONG WITH COINCIDING SUBCATEGORIES AND LINKS (ex. "Category" => array("Sub Category" => "URL to this page") ) */
$navigationArray = array(
		"Dashboard" => array(),
		"Blog" => array("Authors" => "authors.php","Categories" => "categoriesBlog.php","Search Indexes" => "searchIndexes.php"),
		"Organizations" => array("Organizations" => "?panel=organizations","Categories" => "?panel=organization_categories","Tags" => "?panel=organization_tags"),
		"Security" => array("Modify Users" => "users.php")
);

function createMainNav () {
	echo '<!-- main navigagtion -->'."\n";
	echo '<nav id="containerNav" class="sideBar left">'."\n";
	foreach (array_keys($GLOBALS['navigationArray']) as $item) {
		echo "\t".'<section id="'.strtolower($item).'Panel" class="panel">'."\n";
		echo "\t".'<h2>'.ucfirst($item).'</h2>'."\n";
		if (count($GLOBALS['navigationArray'][$item]) > 0) {
			echo "\t\t".'<ul>'."\n";
		}
		foreach (array_keys($GLOBALS['navigationArray'][$item]) as $link) {
			echo "\t\t\t".'<li>'.'<a href="'.$GLOBALS['navigationArray'][$item][$link].'">'.ucfirst($link).'</li>'.'</a>'."\n";
		}
		if (count($GLOBALS['navigationArray'][$item]) > 0) {
			echo "\t\t".'</ul>'."\n";
		}
		echo "\t".'</section>'."\n";
	}
	echo '<!-- end containerNav -->'."\n";
	echo '</nav>'."\n";
}

?>