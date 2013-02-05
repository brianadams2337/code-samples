<?php

include($_SERVER['DOCUMENT_ROOT']."/modules/users/includes/session.php");
include($_SERVER['DOCUMENT_ROOT']."/modules/persons/includes/session.php");

class AdminProcess {

	function AdminProcess(){
	
		if ($_POST['processpersons']) {
			$this->proc_Persons();
		} else {
			$json = array(
				'error' => true,
				'message' => "Invalid action! _POST was not detected!"
			);
			echo json_encode($json);
			return;
		}
		
	}

	function proc_Persons(){
		global $db_persons, $database, $mailer;

		// add person
		if (!isset($_POST['person_id']) || $_POST['person_id'] == "") {

			if (!empty($_FILES)) {

				$image_id_array = array();

				foreach($_FILES as $vark => $file) {
				
					if ($_FILES[$vark]['name']) {
					
						//$target_path = "../../../upl/"; // path from persons module folder
						$target_path = "../upl/";
						//$file_name = $_FILES[$vark]['name'];
						$file_name = time()."_".rand(10000000, 99999999).".jpg";
						$ext = pathinfo($file_name, PATHINFO_EXTENSION);
						$file_name = getSafeFilename($file_name);
						$file_location = $target_path.$file_name;
			
						move_uploaded_file($_FILES[$vark]['tmp_name'], $file_location);
						
						$temp_file_name = str_replace(".$ext", "", $file_name);
						$new_file_name = $temp_file_name."_600.".$ext;	
						$thumbnail = $temp_file_name."_150.".$ext;
						$upload_type = "PERSONS";
			
						$size = getimagesize($target_path.$file_name);
			
						square_crop($target_path.$file_name, $target_path.$thumbnail, 150, 90);
			
						if($size[0] > $size[1]) {
							makethumb($file_name, $target_path, 600, "_600", $target_path, "width");				
						} else {
							makethumb($file_name, $target_path, 600, "_600", $target_path, "height");
						}
			
						$image_id_array[] = $db_persons->add_uploads($_POST['user_id'], $upload_type, $new_file_name, $thumbnail);
			
						@unlink($target_path.$_FILES[$vark]['tmp_name']);
			
						switch ($_FILES[$vark]['error']) {
							case 0:
								$msg = "";
								break;
							case 1:
								$msg = "The file is bigger than this PHP installation allows";
								break;
							case 2:
								$msg = "The file is bigger than this form allows";
								break;
							case 3:
								$msg = "Only part of the file was uploaded";
								break;
							case 4:
								$msg = "No file was uploaded";
								break;
							case 6:
								$msg = "Missing a temporary folder";
								break;
							case 7:
								$msg = "Failed to write file to disk";
								break;
							case 8:
								$msg = "File upload stopped by extension";
								break;
							default:
								$msg = "unknown error ".$_FILES[$vark]['error'];
								break;
						}
		
						if($msg) { 
				
							$json = array(
								'error' => true,
								'message' => "Error: ".$_FILES[$vark]['error']." Error Info: ".$msg
							);
								
						}

					} // end if $_FILES[]['name']

				} // end foreach $_FILES

			} // end if $_FILES

			$date = time();
			
			if(empty($image_id_array)) { $image_id_array = 0; }
			if(empty($_POST['alias'])) { $alias = 0; } else { $alias = $_POST['alias']; }
	
			$person_id = $db_persons->add_person($_POST['user_id'], $_POST['prog_id'], $_POST['type_id'], $_POST['firstname'], $_POST['middlename'], $_POST['lastname'], $_POST['gender'], $_POST['age'], $_POST['race'], $_POST['weight'], $_POST['height'], $_POST['description'], $date);
			
			if($person_id) {
				
				// update image records
				if($image_id_array) {
					foreach($image_id_array as $k => $v)  {
						$db_persons->update_uploads($v, "person_id", $person_id);
						$db_persons->set_uploads($v, $person_id);
					}
				}

				if($alias) {
					foreach($alias as $k => $v) {
						$db_persons->add_alias($v, $person_id);
					}
				}
				
				$json = array(
					'success' => true,
					'message' => "Person added."
				);
				
			}

		// edit person
		} 
		else if (isset($_POST['person_id']) && $_POST['person_id'] != "") {
				
				if (!empty($_FILES)) {
	
					$image_id_array = array();
	
					foreach($_FILES as $vark => $file) {
					
						if ($_FILES[$vark]['name']) {
						
							//$target_path = "../../../upl/"; // path from persons module folder
							$target_path = "../upl/";
							//$file_name = $_FILES[$vark]['name'];
							$file_name = time()."_".rand(10000000, 99999999).".jpg";
							$ext = pathinfo($file_name, PATHINFO_EXTENSION);
							$file_name = getSafeFilename($file_name);
							$file_location = $target_path.$file_name;
				
							move_uploaded_file($_FILES[$vark]['tmp_name'], $file_location);
							
							$temp_file_name = str_replace(".$ext", "", $file_name);
							$new_file_name = $temp_file_name."_600.".$ext;	
							$thumbnail = $temp_file_name."_150.".$ext;
							$upload_type = "PERSONS";
				
							$size = getimagesize($target_path.$file_name);
				
							square_crop($target_path.$file_name, $target_path.$thumbnail, 150, 90);
				
							if($size[0] > $size[1]) {
								makethumb($file_name, $target_path, 600, "_600", $target_path, "width");				
							} else {
								makethumb($file_name, $target_path, 600, "_600", $target_path, "height");
							}
				
							$image_id_array[] = $db_persons->add_uploads($_POST['user_id'], $upload_type, $new_file_name, $thumbnail);
				
							@unlink($target_path.$_FILES[$vark]['tmp_name']);
				
							switch ($_FILES[$vark]['error']) {
								case 0:
									$msg = "";
									break;
								case 1:
									$msg = "The file is bigger than this PHP installation allows";
									break;
								case 2:
									$msg = "The file is bigger than this form allows";
									break;
								case 3:
									$msg = "Only part of the file was uploaded";
									break;
								case 4:
									$msg = "No file was uploaded";
									break;
								case 6:
									$msg = "Missing a temporary folder";
									break;
								case 7:
									$msg = "Failed to write file to disk";
									break;
								case 8:
									$msg = "File upload stopped by extension";
									break;
								default:
									$msg = "unknown error ".$_FILES[$vark]['error'];
									break;
							}
			
							if($msg) { 
					
								$json = array(
									'error' => true,
									'message' => "Error: ".$_FILES[$vark]['error']." Error Info: ".$msg
								);
									
							}
	
						} // end if $_FILES[]['name']
	
					} // end foreach $_FILES
	
				} // end if $_FILES
		
				$db_persons->update_person($_POST['person_id'], "user_id", $_POST['user_id']);
				$db_persons->update_person($_POST['person_id'], "prog_id", $_POST['prog_id']);
				$db_persons->update_person($_POST['person_id'], "type_id", $_POST['type_id']);
				$db_persons->update_person($_POST['person_id'], "firstname", $_POST['firstname']);
				$db_persons->update_person($_POST['person_id'], "middlename", $_POST['middlename']);
				$db_persons->update_person($_POST['person_id'], "lastname", $_POST['lastname']);
				$db_persons->update_person($_POST['person_id'], "gender", $_POST['gender']);
				$db_persons->update_person($_POST['person_id'], "age", $_POST['age']);
				$db_persons->update_person($_POST['person_id'], "race", $_POST['race']);
				$db_persons->update_person($_POST['person_id'], "weight", $_POST['weight']);
				$db_persons->update_person($_POST['person_id'], "height", $_POST['height']);
				$db_persons->update_person($_POST['person_id'], "description", $_POST['description']);
				
				if(empty($image_id_array)) { $image_id_array = 0; }

				if($image_id_array) {
					foreach($image_id_array as $k => $v)  {
						$db_persons->update_uploads($v, "person_id", $_POST['person_id']);
					}
				}

				$db_persons->delete_aliases($_POST['person_id']);
		
				if($alias) {
					foreach($alias as $k => $v) {
						$db_persons->add_alias($v, $_POST['person_id']);
					}
				}

				$json = array(
					'success' => true,
					'message' => "Person edited."
				);

		} 
		else {
			$json = array(
				'error' => true,
				'message' => "Invalid action! The person_id is missing!"
			);
		}

		echo json_encode($json);

	}

};

$adminprocess = new AdminProcess;
?>