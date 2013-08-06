var AjaxFixture = {
	create: {
		success: {
			status: 200,
			responseJSON: {
			    "status": "success",
			    "data": {
			        "id": 13,
			        "phone": "18474210838",
			        "message_frequency": 1
			    }
		    }
		}, 

		fail: { 
			staus: 400,
			responseJSON: {
				"status":"fail",
				"data": {
					"phone":"has already been taken"
				}
			}
		},

		error: {
			status: 500,
			responseJSON: {
				"status": "error",
		        "message": "Something nasty happened and we were unable to complete your request"
			}
		}
	},

	verify: {
		success: {
			status: 200,
			responseJSON: {
			    "status": "success",
			    "data": true
		    }
		},

		fail: {
			status: 400,
			responseJSON: {
				"status":"fail",
				"data":{
					"verification_token":"can't be blank"
				}
			}
		},
		error: {
			status: 500,
			responseJSON: {
			    "status": "error",
			    "message": "The verification code you entered is not correct or is too old. Please request a new code"
			}
		}
	},

	update: {
		success: {
			status: 200,
			responseJSON: {
			    "status": "success",
			    "data": {
			        "id": 13,
			        "phone": "18474210838",
			        "message_frequency": 1
			    }
			}
		}, 

		fail: { 
			status: 400,
			responseJSON: {
				"status":"fail",
				"data": {
					"phone":"has already been taken"
				}
			}
		},

		error: {
			status: 500,
			responseJSON: {
				"status": "error",
		        "message": "Something nasty happened and we were unable to complete your request"
		    }
		}
	}
}