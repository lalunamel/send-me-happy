[
	"I'm super glad to tell you that your verification code is _verification_code_!",
	"Hey cool cat, you're going to receive messages from Send Me Happy about every _message_frequency_ days. Have a good time with it :]"
]
.each { |text|
	Template.create text:text, classification: "system"
}	