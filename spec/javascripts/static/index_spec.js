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

	it("should bind handleReset to keydown on input.error elements", function() {
		var $input = $phoneButton.siblings('input').addClass('error');
		index.init();
		expect($input).toHandleWith('keydown', Smh.StaticController.index.handleReset);
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
	var $button, event, spyEvent;

	beforeEach(function(){
		$input = $('.sign-up-flow-container .phone input');
		$button = $('.sign-up-flow-container .phone .button');

		$input.val(123);
		$button.click(index.submitData);
		
		spyEvent = spyOnEvent($('.sign-up-flow-container .phone .button'), 'click');
		jasmine.Ajax.useMock();

		index.init();
	});

	describe("always", function() {
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

		it("should create a new ladda", function() {
			spyOn(Ladda, 'create').andCallThrough();
			$button.click();
			expect(Ladda.create).toHaveBeenCalledWith($button[0]);
		});

		it("should start a ladda", function() {
			var spyLadda = jasmine.createSpy();
			spyLadda.start = jasmine.createSpy("start");
			spyOn(Ladda, 'create').andReturn(spyLadda);

			$button.click();
			expect(spyLadda.start).toHaveBeenCalled();
		});

		it("should call resetMessage", function() {
			spyOn(index, 'resetMessage');
			$button.click();
			expect(index.resetMessage).toHaveBeenCalledWith($input);
		}); 
	});
	
	describe("success", function() {
		beforeEach(function() {
			spyOn($, 'ajax').andReturn($.Deferred().resolve(AjaxFixture.create.success));
		});

		it("should stop a ladda when the ajax succeeds", function() {
			var spyLadda = jasmine.createSpy();
			spyLadda.start = $.noop;
			spyOn(Ladda, 'create').andReturn(spyLadda);
			spyLadda.stop = jasmine.createSpy("stop");
			$button.click();
			expect(spyLadda.stop).toHaveBeenCalled();
		});

		it("should not call slideSectionUp when a button without class .forward is pressed", function() {
			$button = $('.sign-up-flow-container .button.backward').first();
			spyOn(index, 'slideSectionUp');
			$button.click();
			expect(index.slideSectionUp).not.toHaveBeenCalled();
		});
	});	

	describe("failure", function() {
		beforeEach(function(){
			spyOn(index, 'insertMessage');
			spyOn($, 'ajax').andReturn($.Deferred().reject(AjaxFixture.create.fail));
		});

		it("should insert an error on failed response", function(){
			$button.click();
			expect(index.insertMessage).toHaveBeenCalledWith($input, "That phone is already registered", true);
		});

		it("should stop a ladda when the ajax fails", function() {
			var spyLadda = jasmine.createSpy();
			spyLadda.start = $.noop;
			spyOn(Ladda, 'create').andReturn(spyLadda);
			spyLadda.stop = jasmine.createSpy("stop");
			$button.click();
			expect(spyLadda.stop).toHaveBeenCalled();
		});
	});

	describe("error", function() {
		beforeEach(function() {
			spyOn(index, 'insertMessage');
			spyOn($, 'ajax').andReturn($.Deferred().reject(AjaxFixture.create.error));
		});

		it("should handle ajax failure", function() {
			$button.click();
			expect(index.insertMessage).toHaveBeenCalledWith($input, "Something nasty happened and we were unable to complete your request", true);
		});

		it("should insert 'Something nasty happened and we were unable to complete your request' on error response", function(){
			$button.click();
			expect(index.insertMessage).toHaveBeenCalledWith($input, "Something nasty happened and we were unable to complete your request", true);
		});
	});
});

describe("#insertMessage", function() {
	var $section, message, $input;
	
	beforeEach(function() {
		$section = $('.sign-up-flow-container .phone');
		$input = $section.find("input");
		$input.val("robotz");
		message = "hello world!";
	});
	
	it("should insert a message inside the input placeholder", function() {
		index.insertMessage($input, message);
		var $insertedMessage = $input.attr('placeholder');

		expect($insertedMessage).toBe(message);
	});

	it("should store the original placeholder in a data-placeholder attr", function() {
		originalPlaceholder = $input.attr('placeholder');
		index.insertMessage($input, message);
		expect($input.data('placeholder')).toBe(originalPlaceholder);
	});

	it("should apply the error class to the input if 'error' is true", function() {
		index.insertMessage($input, message, true);
		expect($input).toBe("input.error");
	});

	it("should remove whatever is in the input", function() {
		index.insertMessage($input, message, true);
		expect($input.val()).toBe("");
	});
});

describe("resetMessage", function() {
	var message = "hello world",
		error = "ERROR DOES NOT COMPUTE",
		$input;


	describe("successful case", function() {
		beforeEach(function() {
			$input = $('.phone input');
			$input.addClass("error");
			$input.attr("data-placeholder", message);
			$input.attr("placeholder", error);

			index.resetMessage($input);
		});

		it("should remove the error class from input's parent div", function() {
			expect($input.parent('div').first()).not.toHaveClass("error");
		});

		it("should take the data-placeholder attr and put it in the placeholder attr", function() {
			expect($input.attr('placeholder')).toBe(message);
		});
	});

	describe("unsuccessful case", function() {
		beforeEach(function() {
			$input = $('.phone input');
			$input.attr("data-placeholder", message);
			$input.attr("placeholder", error);

			index.resetMessage($input);
		});

		it("should not do anything if input does not have class error", function() {
			expect($input.attr('placeholder')).toBe("ERROR DOES NOT COMPUTE");
		});
	});


});