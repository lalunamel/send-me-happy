[
	"I'm super glad to tell you that your verification code is _verification_code_!",
	"Hey cool cat, you're going to receive messages from Send Me Happy about every _message_frequency_ days. Have a good time with it :]"
]
.each { |text|
	Template.create text:text, classification: "system"
}

[
	"You've got some great hair!",
	"You're doing a great job today. Keep it up!",
	"You've probably got some pretty great shoes on. Take a moment to appreciate how great your shoes are.",
	"Good luck with your work today, I'm sure you'll do great.",
	"You probably have some really great friends. What's the funniest thing you've done with them in the past month?",
	"Have you been spending a lot of time in front of a screen? Computers are fun, but I think people are better. Go out with your friends tonight!"
]
.each { |text|
	Template.create text:text, classification: "user"
}	