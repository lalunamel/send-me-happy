beforeEach(function() {
	loadFixtures('static_spec.html');
});

describe("#insertErrorMessage", function() {
	var $section;
	var message;
	
	beforeEach(function() {
		$section = $('.sign-up-flow-container .phone');
		message = "hello world!";
	});
	
	it("should insert a message in a <p> into a section", function() {
		Smh.StaticController.index.insertErrorMessage($section.find('input,select'), message);
		var $insertedMessage = $section.find("p.message");
		var $inputElement = $section.find("input,select");

		expect($insertedMessage).toBe("p.message");
		expect($insertedMessage).toHaveText(message);
		expect($inputElement.next()).toBe("p");
	});
});