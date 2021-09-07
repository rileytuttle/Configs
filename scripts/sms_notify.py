from twilio.rest import Client

account_sid = "AC58f635513c7be472b3e180a6c7455ad3"
auth_token = "348bed92a2d8e69b2697f7da808ee3aa"

client = Client(account_sid, auth_token)

PROVIDED_FROM_NUMBER = "+16062685234"
MY_PHONE = "+14013235271"

def send_sms(message_text, from_number=PROVIDED_FROM_NUMBER, to_number=MY_PHONE):
    message = client.messages.create(body=message_text,
                                     from_=from_number,
                                     to=to_number)
    print(message_text)
