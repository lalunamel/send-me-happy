var AjaxMocks = {
	create: {
		success: {
		    "status": "success",
		    "data": {
		        "id": 13,
		        "phone": "18474210838",
		        "message_frequency": 1
		    }
		}, 

		fail: { 
			"status":"fail",
			"data": {
				"phone":"has already been taken"
			}
		},

		error: {
			"status": "error",
	        "message": "There was a problem sending your message. Please try again later"
		}
	},

	validate_token: {
		success: {
		    "status": "success",
		    "data": true
		},

		fail: {},
		error: {
		    "status": "error",
		    "message": "The verification code you entered is not correct or is too old. Please request a new code"
		}
	},

	update: {
		success: {
		    "status": "success",
		    "data": {
		        "id": 13,
		        "phone": "18474210838",
		        "message_frequency": 1
		    }
		}, 

		fail: { 
			"status":"fail",
			"data": {
				"phone":"has already been taken"
			}
		},

		error: {
			"status": "error",
	        "message": "There was a problem saving the User. Please try again later"
		}
	}
}