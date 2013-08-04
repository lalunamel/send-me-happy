var AjaxFixture = {
	create: {
		success: {
			status: 200,
			responseText: JSON.stringify({
			    "status": "success",
			    "data": {
			        "id": 13,
			        "phone": "18474210838",
			        "message_frequency": 1
			    }
		    })
		}, 

		fail: { 
			staus: 400,
			responseText: JSON.stringify({
				"status":"fail",
				"data": {
					"phone":"has already been taken"
				}
			})
		},

		error: {
			status: 500,
			responseText: JSON.stringify({
				"status": "error",
		        "message": "Something nasty happened and we were unable to complete your request"
			})
		}
	},

	verify: {
		success: {
			status: 200,
			responseText: JSON.stringify({
			    "status": "success",
			    "data": true
		    })
		},

		fail: {
			status: 400,
			responseText: JSON.stringify({
				"status":"fail",
				"data":{
					"verification_token":"can't be blank"
				}
			})
		},
		error: {
			status: 500,
			responseText: JSON.stringify({
			    "status": "error",
			    "message": "The verification code you entered is not correct or is too old. Please request a new code"
			})
		}
	},

	update: {
		success: {
			status: 200,
			responseText: JSON.stringify({
			    "status": "success",
			    "data": {
			        "id": 13,
			        "phone": "18474210838",
			        "message_frequency": 1
			    }
			})
		}, 

		fail: { 
			status: 400,
			responseText: JSON.stringify({
				"status":"fail",
				"data": {
					"phone":"has already been taken"
				}
			})
		},

		error: {
			status: 500,
			responseText: JSON.stringify({
				"status": "error",
		        "message": "Something nasty happened and we were unable to complete your request"
		    })
		}
	}
}