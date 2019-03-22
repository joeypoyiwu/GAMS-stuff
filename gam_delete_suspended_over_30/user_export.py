import os
import datetime
import smtplib
import yaml
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders

#Pulls credentials from a yaml file
creds = yaml.load(open('creds.yml'))

sender_email = creds['user']['sender']
receiver_email = creds['user']['receiver']
password = creds['user']['password']

d = datetime.datetime.today()
today = d.strftime('%Y-%m-%d')
filename = "suspended_users_" + str(today) + ".csv"
print(filename)

def send_email():

    subject = "CSV Export of Suspended Users within the last 30 days from today."
    body = "See attached for list of suspended users from the last 30 days since " +str(today)

    msg = MIMEMultipart()
    msg["From"] = sender_email
    msg["To"] = receiver_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, "plain"))
    filename = "suspended_users_" + str(today) + ".csv"
    attachment = open("/Users/joey.wu/Documents/scripts/gam_delete_suspended_over_30/csv/suspended_users_" + str(today) +".csv", "rb")
    p = MIMEBase('application', 'octet-stream')
    p.set_payload((attachment).read())
    encoders.encode_base64(p)
    p.add_header('Content-Disposition', "attachment; filename= %s" % filename)
    msg.attach(p)
    s = smtplib.SMTP('smtp.gmail.com', 587)
    s.starttls()
    s.ehlo()
    s.login(sender_email, password)
    text = msg.as_string()
    s.sendmail(sender_email, receiver_email, text)
    s.quit()
    print("Email sent to " +str(receiver_email) + ".")

send_email()


#See if it's possible to set script to look at last name of user to pull instead of 'suspended on' 
