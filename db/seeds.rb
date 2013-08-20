[
	"I'm super glad to tell you that your verification code is _verification_code_!"
]
.each { |text|
	Template.create text:text, classification: "system"
}	