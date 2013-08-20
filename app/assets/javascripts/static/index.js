_.mixin(_.string.exports());

Smh.StaticController = Smh.StaticController || {};
Smh.StaticController.index = {
	init: function() {
		// bind button click to submit it's data
		$('.sign-up-flow-container .button').click(this.submitData);
		// bind enter to handleEnter
		$('input').keydown(this.handleEnter);
		$('input').keydown(this.handleReset);
		// hide every step except for the first
		// these will be shown as the user clicks through each step
		$('.verification, .message-frequency, .success-message').hide();
	},

	handleEnter: function(event) {
		if(event.which == 13) { // Enter key code
			$input = $(event.currentTarget);
			$anchor = $input.siblings('a.foreward');
			e = $.Event('click');
			e.currentTarget = $anchor[0];

			$anchor.trigger(e);
		}
	},

	handleReset: function(event) {
		Smh.StaticController.index.resetMessage($(event.currentTarget));
	},

	submitData: function(event) {
		var $button = $(event.currentTarget);
		var $input = $button.siblings('input,select');
		var endpoint = $button.data('endpoint');
		var method = $button.data('method');

		var ladda = Ladda.create($button[0]);
		ladda.start();

		Smh.StaticController.index.resetMessage($input);

	    $.ajax({
	      type: $button.data('method'),
	      dataType: 'json',
	      url: $button.data('endpoint'),
	      data: $button.parent().find('input,select').serialize()
	    })
	    .always(function() {
	    	ladda.stop();
	    })
	    .done(function(response){
	    	if($button.hasClass('foreward')) {
		    	Smh.StaticController.index.slideSectionUp($button.parent());
	    	}
	    })
	    .fail(function(response) {
	    	var message = "", json = response.responseJSON;

    		if(json.status === "fail") {
    			_.each(json.data, function(value, key) {
    				message += value;
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
		if(error) $input.addClass('error');

		$input.val("");
		$input.attr('data-placeholder', $input.attr('placeholder'));
		$input.attr('placeholder', message);
	},

	resetMessage: function($input) {
		if(!$input.hasClass('error')) return;

		$input.removeClass('error');
		$input.val("");
		$input.attr('placeholder', $input.attr('data-placeholder'));
	},

	slideSectionUp: function($element) {
		$element.slideUp();
		$element.next().slideDown();
	}
};

$(function() {
	Smh.StaticController.index.init();
})