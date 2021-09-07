from twilio.rest import Client
import twilio_account_info as info

""" this file assumes a twilio_account_info.py file exists that looks like the following:
        account_sid="AC58f635513c7be472b3e180a6c7455ad3"
        auth_token="fef7a66fe60fdba8ec95ff745c1a6037"
        from_number="+16062685234"
        to_number="+14013235271"
"""

client = Client(info.account_sid, info.auth_token)

def send_sms(message_text, from_number=info.from_number, to_number=info.to_number):
    message = client.messages.create(body=message_text,
                                     from_=from_number,
                                     to=to_number)
    print(message_text)

