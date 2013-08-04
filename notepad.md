# Notepad

## Api
	### Status codes
		200 - Success
		400 - The client did something wrong
		500 - The server did something wrong

	### User facing messages in api responses
		Decision: User facing messages are ok
			**pros**
			 * Don't need to put that logic in the javascript
			 * the apigee rest guide suggests putting user facing messages in error responses

			**cons**
			 * Api responses only return pure data, no extra junk

	### Messages on every request or just errors?
		Decision: Only have messages on errors
			**having messages on success**
				* No client side logic to figure out what happened, just display the message
				* Heavy, brittle, and I like to change my mind about these things

			**not having messages on success**
				* 

	### Breaking register_and_send_code into separate actions
		The logic currently in that action would be put into user create
		User create will always send a verificatoin token after a user has been saved

	### What's the structure of a response?
		* Success: returns object that was acted (create, read, updated, delete) upon
		* Fail (problem with request, ie. invalid phone): returns the object, but only those fields that have errors, along with their errors
			{
				status: 'fail',
				data: {
					phone: "can't be blank"
				}
			}
		* Error (unexpected error/exception on server): returns a message about the problem on the server
			{
				status: 'error',
				message: 'Twillio invalid phone number 12345 can't be a phone number'
			}

	### Verifying a user's code
		Requires that the server knows which verification code to compare against when verifying an input code.
		Options:
			* Store in session -> This seems pretty cool, but need more research
			* Store in hidden input on page -> Simple, but not very elegant

## User Interface
	### How should the user be notified that an action has been completed (message sent, verification code accepted, user updated properly)
		* On success, hide current successful input, and show next. 
		  (User enters phone successfully, phone input dissapears and verification code input appears in it's place)
		  In this case, only one input is visible at a time
		* Show success messages
		* Input would be highlighted green
		


To get jasmine to equate jquery objects:
  if(arguments[0] instanceof jQuery && arguments[1] instanceof jQuery && arguments[0].is(arguments[1])) return true;
