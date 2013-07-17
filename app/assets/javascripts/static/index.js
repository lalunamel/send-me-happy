Smh.StaticController = Smh.StaticController || {};
Smh.StaticController.index = {
	insertErrorMessage: function(afterElement, message) {
		insertedMessageElement = $('<p>' + message + '</p>').addClass('message');
		afterElement.after(insertedMessageElement);
	}
};