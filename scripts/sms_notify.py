from twilio.rest import Client
import twilio_account_info as info

""" this file assumes a twilio_account_info.py file exists that looks like the following:
        account_sid="xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        auth_token="xxxxxxxxxxxxxxxxxxxxxxxxx"
        from_number="+xxxxxxxxxxx"
        to_number="+xxxxxxxxxxx"
"""

client = Client(info.account_sid, info.auth_token)

def send_sms(message_text, from_number=info.from_number, to_number=info.to_number):
    message = client.messages.create(body=message_text,
                                     from_=from_number,
                                     to=to_number)
    print(message_text)

