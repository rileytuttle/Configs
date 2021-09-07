from twilio.rest import Client
import re

class SMSInfo():
    def __init__(self, account_info_file=None):
        self.account_info_file = account_info_file
        self.account_sid = None
        self.auth_token = None
        self.from_number = None
        self.to_number = None
        try:
            self.parse_account_data(account_info_file)
        except Exception as e:
            print(e)
            raise Exception("account file not provided")
        if self.account_sid is None:
            raise Exception("account sid not provided")
        if self.auth_token is None:
            raise Exception("authentication token not provided")
        if self.from_number is None:
            raise Exception("from number is not provided")
        if self.to_number is None:
            import pdb
            pdb.set_trace()
            raise Exception("to number is not provided")
    def parse_account_data(self, info_file):
        with open(info_file, "r") as f:
            for line in f.readlines():
                match = re.match("SID: (.*)", line)
                if match is not None:
                    self.account_sid = match.group(1)
                match = re.match("AUTH_TOKEN: (.*)", line)
                if match is not None:
                    self.auth_token = match.group(1)
                match = re.match("PROVIDED_FROM_NUMBER: (.*)", line)
                if match is not None:
                    self.from_number = match.group(1)
                match = re.match("TO_NUMBER: (.*)", line)
                if match is not None:
                    self.to_number = match.group(1)

account_info_file = "twilio_account_info.txt"
""" this assumes a file with the following info and format
        SID: XXXXXXXXXXXXXXXXXXXXX
        AUTH_TOKEN: XXXXXXXXXXXXXXXXXXXX
        PROVIDED_FROM_NUMBER: +XXXXXXXXXXX
        TO_NUMBER: +XXXXXXXXXXX
"""

info = SMSInfo(account_info_file)
client = Client(info.account_sid, info.auth_token)

def send_sms(message_text, from_number=info.from_number, to_number=info.to_number):
    message = client.messages.create(body=message_text,
                                     from_=from_number,
                                     to=to_number)
    print(message_text)

