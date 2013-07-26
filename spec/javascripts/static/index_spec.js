var index, $buttons;
beforeEach(function() {
	loadFixtures('static_spec.html');
	index = Smh.StaticController.index;
	jasmine.Ajax.useMock();
	buttons = $('.sign-up-flow-container .button');
});

describe("#init", function() {
	it("should bind the submitForm function to the click event", function() {
		spyOn(index, 'submitForm');

		index.init();
		buttons.first().click();
		expect(index.submitForm).toHaveBeenCalled();
	}); 
});

describe("#submitForm", function() {
	var $button, event, $form, spyEvent, $ajax;

	beforeEach(function(){
		$button = $('.sign-up-flow-container .phone .button');
		$button.click(index.submitForm);
		spyEvent = spyOnEvent($('.sign-up-flow-container .phone .button'), 'click');
		jasmine.Ajax.useMock();
		$ajax = jasmine.Ajax.jQueryMock().send(AjaxMocks.register_and_send_code.fail);
	});

	it("should make an ajax call", function() {
		spyOn($, 'ajax').andReturn($.Deferred().promise());
		$button.click();
		expect($.ajax).toHaveBeenCalledWith({
			type: "post",
			url: "/users/register_and_send_code",
			data: "phone=123"
		});
	}); 

	it("should prevent default on event", function() {
		$button.click();
		expect(spyEvent).toHaveBeenPrevented();
	}); 	

	it("should clear the previous message before making the ajax request", function() {
		$button.siblings('input').after($('<p>hello world!</p>').addClass('message'));
		$button.click();
		$button.click();
		$button.click();
		expect($('.sign-up-flow-container .phone p').length).toBe(1);
	}); 

	it("should insert 'Message sent' on successful response", function(){
		spyOn($, 'ajax').andCallFake(function(req){
			var deferred = $.Deferred();
			deferred.resolve(AjaxMocks.register_and_send_code.success);
			return deferred.promise();
		});
		$button.click();
		expect($button.siblings('p')).toHaveText("Your message has been sent");
	});

	it("should insert an error on failed response", function(){
		spyOn($, 'ajax').andCallFake(function(req){
			var deferred = $.Deferred();
			deferred.resolve(AjaxMocks.register_and_send_code.fail);
			return deferred.promise();
		});
		$button.click();
		expect($button.siblings('p')).toHaveText("Please enter a valid number");
	});

	it("should insert 'There was a problem sending your message. Please try again later' on error response", function(){
		spyOn($, 'ajax').andCallFake(function(req){
			var deferred = $.Deferred();
			deferred.resolve(AjaxMocks.register_and_send_code.error);
			return deferred.promise();
		});
		$button.click();
		expect($button.siblings('p')).toHaveText("There was a problem sending your message. Please try again later");
	});

	it("should get a message if responseJSON is defined on the response", function() {
		spyOn($, 'ajax').andCallFake(function(req){
			var deferred = $.Deferred();
			response = {};
			response.responseJSON = AjaxMocks.register_and_send_code.success;
			response.responseText = JSON.stringify(AjaxMocks.register_and_send_code.success)
			deferred.resolve(response);
			return deferred.promise();
		});
		$button.click();
		expect($button.siblings('p')).toHaveText("Your message has been sent");
	});
});

describe("#insertMessage", function() {
	var $section, message, $inputElement;
	
	beforeEach(function() {
		$section = $('.sign-up-flow-container .phone');
		$inputElement = $section.find("input");
		message = "hello world!";
	});
	
	it("should insert a message in a <p> into a section after an input or select element", function() {
		index.insertMessage($section.find('input'), message);
		var $insertedMessage = $section.find("p.message");

		expect($insertedMessage).toBe("p.message");
		expect($insertedMessage).toHaveText(message);
		expect($inputElement.next()).toBe("p");
	});

	it("should should also work for a select element", function() {
		$section = $('.sign-up-flow-container .message-frequency');
		index.insertMessage($section.find('select'), message);
		var $insertedMessage = $section.find("p.message");

		expect($insertedMessage).toBe("p.message");
		expect($insertedMessage).toHaveText(message);
		expect($inputElement.next()).toBe("a");
	});

	// Move this functionality into a separate function?
	it("should move the cursor back to the input box", function() {

	});

	// Do we really want to do this?
	it("should delete the last thing in the input box", function() {

	});
});