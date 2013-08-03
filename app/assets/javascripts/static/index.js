Smh.StaticController = Smh.StaticController || {};
Smh.StaticController.index = {
	init: function() {
		$('.sign-up-flow-container .button').click(this.submitForm);
	},

	submitForm: function(event) {
		var $form = $(event.target).closest('form');
		var $input = $form.children('input,select');
		$form.parents('div').first().removeClass('error');
		$form.find('p').remove();
	    $.ajax({
	      type: $form.attr('method'),
	      url: $form.attr('action'),
	      data: $form.serialize()
	    })
	    .done(function(response){ 
	    	var message = "";
	    	if(response.responseJSON !== undefined)
	    		response = response.responseJSON;

	    	if (response.status == "fail") {
	    		for(key in response.data) {
	    			if(message.length > 0) 
	    				message += "\n";
	    			message += "That " + key + " " + response.data[key];
	    		}
	    	}
	    	else if (response.status == "error") {
	    		message = response.message
	    	}

	    	if(!!message) 
		    	Smh.StaticController.index.insertMessage($input, message, true)
	    })
	    .fail(function() {
	    	Smh.StaticController.index.insertMessage($input, "Something nasty happened and we were unable to complete your request", true);
	    });

		event.preventDefault();
	},
 
	insertMessage: function($input, message, error) {
		messageElement = $('<p>' + message + '</p>').addClass('message');
		if(error) $input.parents('div').first().addClass('error');

		if($input.next().is('p')) {
			$input.siblings('p').replaceWith(messageElement);
		}
		else {
			$input.after(messageElement);
		}
	}
};

$(function() {
	Smh.StaticController.index.init();
})