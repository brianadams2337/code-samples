<?php

include($_SERVER['DOCUMENT_ROOT']."/modules/users/includes/session.php");
include($_SERVER['DOCUMENT_ROOT']."/modules/persons/includes/session.php");

class AdminProcess {

	function AdminProcess(){

		if ($_POST['processinteractions']) {
			$this->proc_Interactions();
		} else {
			$json = array(
				'error' => true,
				'message' => "Invalid action!"
			);
			echo json_encode($json);
			return;
		}
		
	}

	function proc_Interactions(){
		global $db_persons, $database;

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
						$upload_type = "INTERACTIONS";
			
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


		$date = explode("-", $_POST['date']);
		$minute = $_POST['minute'];
		$hour = $_POST['hour'];
		$period = $_POST['period'];
		if ($period == "PM") {
			$hour = $hour + 12;
		}
		$pubdate = mktime($hour, $minute, 0, $date[0], $date[1], $date[2]);
		
		if(empty($image_id_array)) { $image_id_array = 0; }

		$int_id = $db_persons->add_interaction($_POST['user_id'], $_POST['prog_id'], $_POST['person_id'], $_POST['type_id'], $_POST['description'], $pubdate);
		
		if($int_id) {
			
			if($image_id_array) {
				foreach($image_id_array as $k => $v)  {
					$db_persons->update_uploads($v, "person_id", $int_id);
					$db_persons->set_uploads($v, $int_id);
				}
			}
			
			$json = array(
				'success' => true,
				'message' => "Interaction added."
			);
			
		}

		echo json_encode($json);

	}	

};

$adminprocess = new AdminProcess;
?>