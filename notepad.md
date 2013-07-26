# Notepad

## Api

### User facing messages in api responses
Decision: User facing messages are ok 
**pros**
 * Don't need to put that logic in the javascript
 * the apigee rest guide suggests putting user facing messages in error responses

**cons**
 * Api responses only return pure data, no extra junk

### Breaking register_and_send_code into separate actions
The logic currently in that action would be put into user create
User create will always send a verificatoin token after a user has been saved

## User Interface
