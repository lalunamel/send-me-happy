var index, $phoneButton;
beforeEach(function() {
	loadFixtures('static_spec.html');
	index = Smh.StaticController.index;
	jasmine.Ajax.useMock();
	$phoneButton = $('.sign-up-flow-container .button');
});

describe("#init", function() {
	it("should bind the submitData function to the click event on phoneButton", function() {
		var button = $phoneButton.first()[0];
		index.init();
		expect($phoneButton).toHandleWith('click', Smh.StaticController.index.submitData);
	}); 

	it("should bind the handleEnter function to the keydown event on inputs", function() {
		var $input = $phoneButton.siblings('input');
		index.init();
		expect($input).toHandleWith('keydown', Smh.StaticController.index.handleEnter);
	}); 
});

describe('#handleEnter', function() {
	beforeEach(function() {
		index.init();
		spyOn(Smh.StaticController.index, 'submitData');
	});

	describe("on sections with only one button", function() {
		var e, clickSpy;
		beforeEach(function() {
			clickSpy = spyOnEvent('.sign-up-flow-container .phone .button', 'click');
			e = $.Event('keydown');
		});

		it("should trigger a click on the nearest button when Enter is pressed", function() {
			e.which = 13;
			$phoneButton.siblings('input').trigger(e);

			expect(clickSpy).toHaveBeenTriggered();
		});

		it("should not trigger a click when Enter is not pressed", function() {
			e.which = 99;
			$phoneButton.siblings('input').trigger(e);

			expect(clickSpy).not.toHaveBeenTriggered();
		});
	});

	describe("on sections with two buttons", function() {
		var e, clickSpy;
		beforeEach(function() {
			forewardClickSpy = spyOnEvent('.sign-up-flow-container .verification .button.foreward', 'click');
			backwardClickSpy = spyOnEvent('.sign-up-flow-container .verification .button.backward', 'click');
			e = $.Event('keydown');
			e.which = 13;
		});
		
		it("should only trigger a click event on phoneButton with class .success", function() {
			$('.sign-up-flow-container .verification input').trigger(e);

			expect(forewardClickSpy).toHaveBeenTriggered();
			expect(backwardClickSpy).not.toHaveBeenTriggered();
		});
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