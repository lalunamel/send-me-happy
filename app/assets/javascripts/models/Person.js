(function(){
	var Person = Backbone.model.extend({
        defaults: {
            phone: '',
            verification_token: '',
            message_frequency: 1
        }
	});
})();