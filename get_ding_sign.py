#!/usr/bin/env python
# -*- coding: utf8 -*-
import time
import hmac
import hashlib
import base64
import urlparse
import urllib
#import urllib2


timestamp = "%d" % (time.time() * 1000)
#timestamp = round(time.time() * 1000)
secret = 'SEC9a5cb38ae0bfdaf2b02ac1ced330c6d5373167e6a96f6fe0d76308283bc78529'
secret_enc = secret.encode('utf-8')
string_to_sign = '{}\n{}'.format(timestamp, secret)
string_to_sign_enc = string_to_sign.encode('utf-8')
hmac_code = hmac.new(secret_enc, string_to_sign_enc, digestmod=hashlib.sha256).digest()
sign = urllib.quote(base64.b64encode(hmac_code))
print timestamp
print sign
