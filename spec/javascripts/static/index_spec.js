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
		$form = $('.sign-up-flow-container .phone form');
		$input = $form.children('input,select');
		$button = $('.sign-up-flow-container .phone .button');

		$input.val(123);
		$button.click(index.submitForm);
		
		spyEvent = spyOnEvent($('.sign-up-flow-container .phone .button'), 'click');
		jasmine.Ajax.useMock();
		$ajax = jasmine.Ajax.jQueryMock().send(AjaxMocks.create.fail);
	});

	it("should make an ajax call", function() {
		spyOn($, 'ajax').andReturn($.Deferred().promise());
		$button.click();
		expect($.ajax).toHaveBeenCalledWith({
			type: "post",
			url: "/users",
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

	it("should remove the error class from the container", function() {
		index.insertMessage($input, "", false);
		$button.click();
		expect($form.parent()).not.toHaveClass('error');
	});

	it("should remove message next to the button clicked", function() {
		index.insertMessage($input, "", false);
		$button.click();
		expect($form.parent()).not.toContain('p.message');
	});

	describe("on failure or error", function() {
		beforeEach(function(){
			spyOn(index, 'insertMessage');
		});

		it("should handle ajax failure", function() {
			spyOn($, 'ajax').andReturn($.Deferred().reject());
			$button.click();
			expect(index.insertMessage).toHaveBeenCalledWith($input, "Something nasty happened and we were unable to complete your request", true);
		});

		it("should insert an error on failed response", function(){
			spyOn($, 'ajax').andCallFake(function(req){
				var deferred = $.Deferred();
				deferred.resolve(AjaxMocks.create.fail);
				return deferred.promise();
			});
			$button.click();
			expect(index.insertMessage).toHaveBeenCalledWith($input, "That phone has already been taken", true);
		});

		it("should insert 'There was a problem sending your message. Please try again later' on error response", function(){
			spyOn($, 'ajax').andCallFake(function(req){
				var deferred = $.Deferred();
				deferred.resolve(AjaxMocks.create.error);
				return deferred.promise();
			});
			$button.click();
			expect(index.insertMessage).toHaveBeenCalledWith($input, "There was a problem sending your message. Please try again later", true);
		});

		it("should get a message if responseJSON is defined on the response", function() {
			spyOn($, 'ajax').andCallFake(function(req){
				var deferred = $.Deferred();
				response = {};
				response.responseJSON = AjaxMocks.create.fail;
				response.responseText = JSON.stringify(AjaxMocks.create.success)
				deferred.resolve(response);
				return deferred.promise();
			});
			$button.click();
			expect(index.insertMessage).toHaveBeenCalledWith($input, "That phone has already been taken", true);
		});
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
	it("should apply the error class to the container if 'error' is true", function() {
		index.insertMessage($section.find('input'), message, true);

		expect($section).toBe("div.error");
	});
});