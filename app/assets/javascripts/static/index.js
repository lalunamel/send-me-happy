Smh.StaticController = Smh.StaticController || {};
Smh.StaticController.index = {
	init: function() {
		$('.sign-up-flow-container .button').click(this.submitForm);
	},

	submitForm: function(event) {
		var $form = $(event.target).closest('form');
		var $input = $form.children('input,select');
		var that = this;
	    $.ajax({
	      type: $form.attr('method'),
	      url: $form.attr('action'),
	      data: $form.serialize()
	    })
	    .always(function(response){ 
	    	var message = "";
	    	if(response.responseJSON !== undefined)
	    		response = response.responseJSON;

	    	if (response.status == "success") {
	    		message = response.data;
	    	}
	    	else if (response.status == "fail") {
	    		for(key in response.data) {
	    			message += response.data[key];
	    			message += "\n";
	    		}
	    	}
	    	else if (response.status == "error") {
	    		message = response.message
	    	}
	    	else {
	    		message = "An error occurred while talking to the server. Please contact support"
	    	}
	    	Smh.StaticController.index.insertMessage($input, message)
	    });

		event.preventDefault();
	},
 
	insertMessage: function(input, message) {
		messageElement = $('<p>' + message + '</p>').addClass('message');
		if(input.next().is('p')) {
			input.siblings('p').replaceWith(messageElement);
		}
		else {
			input.after(messageElement);
		}
	}
};

$(function() {
	Smh.StaticController.index.init();
})