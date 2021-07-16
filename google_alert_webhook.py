#!/usr/bin/env python3.7
#-*- coding: utf8 -*-                              
                                                   
import sys
import requests
import logging


from flask import Flask                    
from flask import request,Response

try:
    import json
except ImportError:
    import simplejson as json


#logger = logging.getLogger(__name__)
logging.basicConfig(handlers=[logging.FileHandler(filename="./google_alert.log", 
                                                 encoding='utf-8', mode='a+')],
                    format="%(asctime)s %(name)s:%(levelname)s:%(message)s", 
                    datefmt="%F %A %T", 
                    level=logging.INFO)
#root_logger= logging.getLogger()
#root_logger.setLevel(logging.DEBUG)
#handler = logging.FileHandler('google_alert.log', 'w', 'utf-8')
#handler.setFormatter(logging.Formatter('%(name)s %(message)s')) # or whatever
#root_logger.addHandler(handler)


app = Flask(__name__)                              


@app.route('/', methods=['POST'])
def simple_handler():
    """ Handle a webhook post with no authentication method """
    json_data = json.loads(request.data)
    logging.info(json.dumps(json_data, indent=4))
    return Response("OK")


@app.route('/gunim', methods=['POST'])
def basic_auth_handler():
    """ Handle a webhook post with basic HTTP authentication """
    auth = request.authorization
    print(auth)

    if not auth or not _check_basic_auth(auth.username, auth.password):
        error_msg = '401 Could not verify your access level for that URL. You have to login with proper credentials'
        logging.error(error_msg)
        # A correct 401 authentication challenge with the realm specified is required
        return Response(error_msg, 401, {'WWW-Authenticate': 'Basic realm="Login Required"'})
    else:
        #a = _check_basic_auth(auth.username, auth.password)
        #print(a)
        """ Handle a webhook post with an associated authentication token """
        auth_token = request.args.get('auth_token')
        if not auth_token or not _check_token_auth(auth_token):
            error_msg = '403 Please pass the correct authentication token'
            logging.error(error_msg)
            return Response(error_msg, 403)

        else:
            data = []
            # OPS dingding
            #token = '606f562c15f25a53af2f1c27cd102fc82255055961aad10c4e80846d5e00ee9d'

            # chat dingding
            #token = '8908dea65587d7ac4fca1efc3f07b5fe212a2b60db8b59ddfbf66d6fa10d926e'
            if request.method == 'POST':                   
                # first mothed
                #json_data = json.loads(request.data)
                #source_data = json_data["incident"]

                # second mothed
                respon = request.get_json(force=True)    
                logging.info(json.dumps(respon, indent=4))
                # get type parameter
                type = request.args.get("type")
                type_msg = "The type parameter value: " + type
                logging.info(type_msg)
                # get dingding token
                ding_token = request.args.get("ding_token")
   
                if type == "OPS":
                    # from json data get key's object
                    if respon.get("incident"):
                        source_data = respon.get("incident")
                    else:
                        error_msg = '400 json format is error'
                        logging.error(error_msg)
                        return Response(error_msg, 400)
                    #
                    content = source_data["documentation"]["content"]
                    policy_name = source_data["policy_name"]
                    state = source_data["state"]
                    # judge post parameter
                    if state == "open":
                        subject = "Alert: " + policy_name
                        body = "Msg: " + policy_name + " is above the threshold!!!"
                    elif state == "closed":
                        subject = "OK: " + policy_name
                        body = "Msg: the alert for " + policy_name + " returned to normal."
                elif type == "BI":
                    if respon.get("incident"):
                        source_data = respon.get("incident")
                        state = source_data["state"]
                        logging.info("state value : " + state)
                        if state == "open":
                            subject = "BI pubsub_subscription Google Alert"
                            body = "Alert: Unacked messages too high"
                        elif state == "closed":
                            subject = "OK: pubsub_subscription Google Alert"
                            body = "Msg: Unacked messages recovery "
                    else:
                        error_msg = "400 BI Data Error"
                        logging.error(error_msg)
                        return Response(error_msg, 400)
        
                # dingding alert 
                Url = 'https://oapi.dingtalk.com/robot/send?access_token=' + ding_token
        
                data = {
                    "msgtype": "actionCard",
                    "actionCard": {
                        "title": subject,
                        "text": "#### " + subject + "\n\n " + body,
                        "btnOrientation": "0"
                    }
                }
        
                header = {"Content-Type": "application/json"}
                data = json.dumps(data)
                logging.info(data)
        
                Res = requests.post(Url,data,headers=header)
                if Res.status_code == 200:
                    logging.info("Great! Request success.")
                else:
                    logging.error("钉钉接口请求错误！")
                return Response("Ok")
            else:                        
                # nothing delete this two line
                name = request.args.get("username")                   
                return Response("My name is ", username)

                                                   
def _check_basic_auth(username, password):
    """This function is called to check if a username / password combination is valid. """
    return username == 'im30_google_alert' and password == '3MPW$$$dF*Rhq*RZ'


def _check_token_auth(auth_token):
    """This function is called to check if a submitted token argument matches the expected token """
    return auth_token == "rHGnbaLE-yMRY-b7Pz-YVQGq2KRmD8nqbQs"


if __name__ == '__main__':                         
    app.run(host='127.0.0.1', port=18341)            
