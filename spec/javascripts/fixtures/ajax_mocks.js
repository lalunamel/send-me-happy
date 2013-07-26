var AjaxMocks = {
	register_and_send_code: {
		success: {
			status: "success",
			data: "Your message has been sent"
		}, 

		fail: {
			status: "fail",
	        data: {
	          phone: "Please enter a valid number"
	        }
		},

		error: {
			status: "error",
	        message: "There was a problem sending your message. Please try again later"
		}
	}
}