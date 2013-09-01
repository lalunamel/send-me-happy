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
* Store in session -* This seems pretty cool, but need more research
* Store in hidden input on page -> Simple, but not very elegant

### Async message delivery
## How to notify client of message status?
Normally, message are sent sychronously, which means the server finishes its request afer a message has either been sent or has errored out.
With aysnchronous message delivery, the server will finish it's request before the message has been sent.  	
**The scheme is now as follows:**  

* The user makes a request to send a message via the API
* The server enqueues a job using stalker
* A stalker worker picks up that job and makes a call to the twilio api
* The stalker job does ??? to signal the status of the completed request to twilio.

**How to signal the status of a message sending request to the client** 

* Client pings server - server keeps status of message in db
* Push the status from server -> client
* initial request (the one that enqueues the message) hangs until job has finished, job signals it's status to initial request, initial request receives status and returns
* somehow do callbacks

## User Interface
### How should the user be notified that an action has been completed (message sent, verification code accepted, user updated properly)
	* On success, hide current successful input, and show next. 
(User enters phone successfully, phone input dissapears and verification code input appears in it's place)
In this case, only one input is visible at a time
	* Show success messages
	* Input would be highlighted 

### Verification code resend
How should requesting another verification code be handled?
Right now: If 'Send verfication code' button is pressed, server returns a 'phone already taken' error
Later: Clicking that button again should try to send a message to your phone again

### Error messages
Options:
Please enter a (ERROR_CORRECT) (NOUN)
That (NOUN) is (ERROR_INCORRECT)

Please enter a valid phone number
Please enter a verification code that matches
Please enter a verification code that is more recent
Please select a valid message frequency

That phone number is not valid
That verification code is not correct
That verification code is too old
That message frequency is not valid

## Jasmine tests
### Mocking ajax requests
####return hand created json file  
	* Slow
	* Probably not accurate
	* Annoying
	* No set up!


####call through to server and get real json back  
	* fast
	* easy?
	* no easy way to stop from making other network requests (twilio)


####record json requests with some util and store them in a fixture  
	* requires me writing it
	* accurate