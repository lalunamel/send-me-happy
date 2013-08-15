var index, $buttons;
beforeEach(function() {
	loadFixtures('static_spec.html');
	index = Smh.StaticController.index;
	jasmine.Ajax.useMock();
	$buttons = $('.sign-up-flow-container .button');
});

describe("#init", function() {
	it("should bind the submitData function to the click event on buttons", function() {
		spyOn(index, 'submitData');

		index.init();
		$buttons.first().click();
		expect(index.submitData).toHaveBeenCalled();
	}); 
});

describe("#submitData", function() {
	var $button, event, spyEvent, $ajax;

	beforeEach(function(){
		$input = $('.sign-up-flow-container .phone input');
		$button = $('.sign-up-flow-container .phone .button');

		$input.val(123);
		$button.click(index.submitData);
		
		spyEvent = spyOnEvent($('.sign-up-flow-container .phone .button'), 'click');
		jasmine.Ajax.useMock();
	});

	it("should make an ajax call", function() {
		spyOn($, 'ajax').andReturn($.Deferred().promise());
		$button.click();
		expect($.ajax).toHaveBeenCalledWith({
			type: "post",
			dataType: 'json',
			url: "/users",
			data: "phone=123"
		});
	}); 

	it("should prevent default on event", function() {
		$button.click();
		expect(spyEvent).toHaveBeenPrevented();
	}); 

	describe("success", function() {
		beforeEach(function() {
			$ajax = jasmine.Ajax.jQueryMock().send(AjaxFixture.create.success);
		});

		// Nothing in here yet	
	});	

	describe("failure", function() {
		beforeEach(function(){
			spyOn(index, 'insertMessage');
			$ajax = jasmine.Ajax.jQueryMock().send(AjaxFixture.create.fail);
		});

		it("should handle ajax failure", function() {
			spyOn($, 'ajax').andReturn($.Deferred().reject(AjaxFixture.create.error));
			$button.click();
			expect(index.insertMessage).toHaveBeenCalledWith($input, "Something nasty happened and we were unable to complete your request", true);
		});

		it("should insert an error on failed response", function(){
			spyOn($, 'ajax').andCallFake(function(req){
				var deferred = $.Deferred();
				return deferred.reject(AjaxFixture.create.fail);
			});
			$button.click();
			expect(index.insertMessage).toHaveBeenCalledWith($input, "Phone has already been taken", true);
		});

		it("should insert 'Something nasty happened and we were unable to complete your request' on error response", function(){
			spyOn($, 'ajax').andCallFake(function(req){
				var deferred = $.Deferred();
				return deferred.reject(AjaxFixture.create.error);
			});
			$button.click();
			expect(index.insertMessage).toHaveBeenCalledWith($input, "Something nasty happened and we were unable to complete your request", true);
		});

		it("should call resetMessages", function() {
			spyOn(index, 'resetMessages');
			$button.click();
			expect(index.resetMessages).toHaveBeenCalled();
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

	it("should apply the error class to the container if 'error' is true", function() {
		index.insertMessage($section.find('input'), message, true);
		expect($section).toBe("div.error");
	});
});

describe("resetMessages", function() {
	beforeEach(function() {
		$(".phone input").addClass("error");
		$(".phone input").after("<p class='message'>hello world</p>");
	});

	it("should remove the error class from inputs that have it", function() {
		index.resetMessages();
		expect($(".phone input")).not.toHaveClass("error");
	});

	it("should remove any paragraph element that has class = message", function() {
		index.resetMessages();
		expect($("p.message")).not.toExist();
	});
});