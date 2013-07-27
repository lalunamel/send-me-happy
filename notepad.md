# Notepad

## Api
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

## User Interface
