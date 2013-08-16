_.mixin(_.string.exports());

Smh.StaticController = Smh.StaticController || {};
Smh.StaticController.index = {
	init: function() {
		// bind button click to submit it's data
		$('.sign-up-flow-container .button').click(this.submitData);
		// bind enter to handleEnter
		$('input').keydown(this.handleEnter);
		// hide every step except for the first
		// these will be shown as the user clicks through each step
		$('.verification, .message-frequency, .success-message').hide();
	},

	handleEnter: function(event) {
		if(event.which == 13) { // Enter key code
			$input = $(event.target);
			$anchor = $input.siblings('a.foreward');
			e = $.Event('click');
			e.target = $anchor[0];

			$anchor.trigger(e);
		}
	},

	submitData: function(event) {
		$button = $(event.target);
		endpoint = $button.data('endpoint');
		method = $button.data('method');

		Smh.StaticController.index.resetMessages();

	    $.ajax({
	      type: $button.data('method'),
	      dataType: 'json',
	      url: $button.data('endpoint'),
	      data: $button.parent().find('input,select').serialize()
	    })
	    .done(function(response){
	    	Smh.StaticController.index.slideSectionUp($button.parent());
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
	},

	resetMessages: function() {
		$('.error').removeClass('error');
		$('p.message').remove();
	},

	slideSectionUp: function($element) {
		$element.slideUp();
		$element.next().slideDown();
	}
};

$(function() {
	Smh.StaticController.index.init();
})