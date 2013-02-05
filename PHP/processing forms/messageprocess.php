<?php

include($_SERVER['DOCUMENT_ROOT']."/modules/users/includes/session.php");
include($_SERVER['DOCUMENT_ROOT']."/modules/maintenance/includes/session.php");

class AdminProcess {

	function AdminProcess(){

		if ($_POST) {
			$this->proc_Messages();
		} else {
			$json = array(
				'error' => true,
				'message' => "Invalid action!"
			);
			echo json_encode($json);
			return;
		}
		
	}

	function proc_Messages(){
		global $db_main, $database;

		$date = explode("-", $_POST['date']);
		$pubdate = strtotime($date[2]."/".$date[0]."/".$date[1]);
		
		if(empty($_POST['image_id'])) { $image_id = 0; } else { $image_id = $_POST['image_id']; }

		$msg_id = $db_main->add_messages($_POST['user_id'], $_POST['prog_id'], $_POST['req_id'], $_POST['message'], $pubdate);
		
		if($msg_id) {
			
			if($image_id) {
				foreach($image_id as $k => $v)  {
					$db_main->update_uploads($v, "req_id", $_POST['req_id']);
					$db_main->set_uploads($v, $msg_id);
				}
			}
			
			$json = array(
				'success' => true,
				'message' => "Message added."
			);
			
		}

		echo json_encode($json);

	}	

};

$adminprocess = new AdminProcess;
?>