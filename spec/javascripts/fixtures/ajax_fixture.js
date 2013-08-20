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
					"phone":"That phone is already registered"
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
					"verification_token":"Please enter a verification token"
				}
			}
		},
		error: {
			status: 500,
			responseJSON: {
			    "status": "error",
			    "message": "That verification code is not corrent"
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
					"phone":"That phone is already registered"
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