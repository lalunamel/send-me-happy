_.mixin(_.string.exports());

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
	      dataType: 'json',
	      url: $form.attr('action'),
	      data: $form.serialize()
	    })
	    .done(function(response){ 
	    	var message = "", json = response.responseJSON;

	    	if (json.status == "fail") {
	    		for(key in json.data) {
	    			if(message.length > 0) 
	    				message += "\n";
	    			message += "That " + key + " " + json.data[key];
	    		}
	    	}
	    	else if (json.status == "error") {
	    		message = json.message
	    	}

	    	if(!!message) 
		    	Smh.StaticController.index.insertMessage($input, message, true)
	    })
	    .fail(function(response) {
	    	var message = "", json = response.responseJSON;

    		if(json.status === "fail") {
    			_.each(json.data, function(value, key) {
    				message += [_(key).capitalize(), " ", value].join("");
    			});
    		}
    		else if(json.status === "error") {
    			message = json.message;
    		}
    		else {
    			message = "Something nasty happened and we were unable to complete your request";
    		}

	    	Smh.StaticController.index.insertMessage($input, message, true);
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