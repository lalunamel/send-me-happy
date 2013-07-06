["SendMeHappy says: Your verification code is "]
.each { |text|
	Template.create text:text, classification: "system"
}	