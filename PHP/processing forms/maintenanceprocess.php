<?php

include($_SERVER['DOCUMENT_ROOT']."/modules/users/includes/session.php");
include($_SERVER['DOCUMENT_ROOT']."/modules/maintenance/includes/session.php");

class AdminProcess {

	function AdminProcess(){
	
		if ($_POST) {
			$this->proc_Requests();
		} else {
			$json = array(
				'error' => true,
				'message' => "Invalid action!"
			);
			echo json_encode($json);
			return;
		}
		
	}

	function proc_Requests(){
		global $db_main, $database;

		// add request
		if (!isset($_POST['req_id']) || $_POST['req_id'] == "") {

			if (!empty($_FILES)) {

				$image_id_array = array();

				foreach($_FILES as $vark => $file) {
				
					if ($_FILES[$vark]['name']) {
					
						//$target_path = "../../../upl/"; // path from maintenance module folder
						$target_path = "../upl/";
						$file_name = $_FILES[$vark]['name'];
						$ext = pathinfo($file_name, PATHINFO_EXTENSION);
						$file_name = getSafeFilename($file_name);
						$file_location = $target_path.$file_name;
			
						move_uploaded_file($_FILES[$vark]['tmp_name'], $file_location);
						
						$temp_file_name = str_replace(".$ext", "", $file_name);
						$new_file_name = $temp_file_name."_600.".$ext;	
						$thumbnail = $temp_file_name."_150.".$ext;
						$upload_type = "MAINTENANCE";
			
						$size = getimagesize($target_path.$file_name);
			
						square_crop($target_path.$file_name, $target_path.$thumbnail, 150, 90);
			
						if($size[0] > $size[1]) {
							makethumb($file_name, $target_path, 600, "_600", $target_path, "width");				
						} else {
							makethumb($file_name, $target_path, 600, "_600", $target_path, "height");
						}
			
						$image_id_array[] = $db_main->add_uploads($_POST['user_id'], $upload_type, $new_file_name, $thumbnail);
			
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
			$date = strtotime($date[2]."/".$date[0]."/".$date[1]);
			
			if(empty($image_id_array)) { $image_id_array = 0; }
	
			$req_id = $db_main->add_requests($_POST['user_id'], $_POST['prog_id'], $_POST['main_id'], $_POST['dep_id'], $_POST['streetnum'], $_POST['address'], $_POST['info'], $_POST['description'], $date);
			
			if($req_id) {
				
				if($image_id_array) {
					foreach($image_id_array as $k => $v)  {
						$db_main->update_uploads($v, "req_id", $req_id);
					}
				}
				
				$json = array(
					'success' => true,
					'message' => "Request added."
				);
				
			}

		// edit request
		} else if (isset($_POST['req_id']) && $_POST['req_id'] != "") {
	
			// update completion status
			if (isset($_POST['complete']) && $_POST['complete'] != "") {
				if ($_POST['complete'] == 0 || $_POST['complete'] == "") {
					$db_main->update_requests($_POST['req_id'], "completeDate", "");

					$json = array(
						'success' => true,
						'message' => "Request re-opened."
					);

				} else {
					$date = explode("-", $_POST['date']);
					$date = strtotime($date[2]."/".$date[0]."/".$date[1]);
					$db_main->update_requests($_POST['req_id'], "completeDate", $date);
					$json = array(
						'success' => true,
						'message' => "Request completed."
					);
				}
				$db_main->update_requests($_POST['req_id'], "complete", $_POST['complete']);


			// update request information
			} else if (!isset($_POST['complete']) || $_POST['complete'] == "") {
			
				if (!empty($_FILES)) {
	
					$image_id_array = array();
	
					foreach($_FILES as $vark => $file) {
					
						if ($_FILES[$vark]['name']) {
						
							//$target_path = "../../../upl/"; // path from maintenance module folder
							$target_path = "../upl/";
							$file_name = $_FILES[$vark]['name'];
							$ext = pathinfo($file_name, PATHINFO_EXTENSION);
							$file_name = getSafeFilename($file_name);
							$file_location = $target_path.$file_name;
				
							move_uploaded_file($_FILES[$vark]['tmp_name'], $file_location);
							
							$temp_file_name = str_replace(".$ext", "", $file_name);
							$new_file_name = $temp_file_name."_600.".$ext;	
							$thumbnail = $temp_file_name."_150.".$ext;
							$upload_type = "MAINTENANCE";
				
							$size = getimagesize($target_path.$file_name);
				
							square_crop($target_path.$file_name, $target_path.$thumbnail, 150, 90);
				
							if($size[0] > $size[1]) {
								makethumb($file_name, $target_path, 600, "_600", $target_path, "width");				
							} else {
								makethumb($file_name, $target_path, 600, "_600", $target_path, "height");
							}
				
							$image_id_array[] = $db_main->add_uploads($_POST['user_id'], $upload_type, $new_file_name, $thumbnail);
				
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
		
				$db_main->update_requests($_POST['req_id'], "user_id", $_POST['user_id']);
				$db_main->update_requests($_POST['req_id'], "prog_id", $_POST['prog_id']);
				$db_main->update_requests($_POST['req_id'], "main_id", $_POST['main_id']);
				$db_main->update_requests($_POST['req_id'], "dep_id", $_POST['dep_id']);
				$db_main->update_requests($_POST['req_id'], "streetnum", $_POST['streetnum']);
				$db_main->update_requests($_POST['req_id'], "address", $_POST['address']);
				$db_main->update_requests($_POST['req_id'], "info", $_POST['info']);
				$db_main->update_requests($_POST['req_id'], "description", $_POST['description']);
				
				$date = explode("-", $_POST['date']);
				$date = strtotime($date[2]."/".$date[0]."/".$date[1]);
				$db_main->update_requests($_POST['req_id'], "date", $date);

				if(empty($image_id_array)) { $image_id_array = 0; }

				if($image_id_array) {
					foreach($image_id_array as $k => $v)  {
						$db_main->update_uploads($v, "req_id", $_POST['req_id']);
					}
				}
		
				$json = array(
					'success' => true,
					'message' => "Request edited."
				);
			}

		} else {
			$json = array(
				'error' => true,
				'message' => "Invalid action!"
			);
		}

		echo json_encode($json);

	}

};

$adminprocess = new AdminProcess;
?>