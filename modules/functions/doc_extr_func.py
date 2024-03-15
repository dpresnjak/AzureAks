# ## Service Bus Trigger
# import logging
# import azure.functions as func

# app = func.FunctionApp()

# @app.function_name(name="dpres-sqs-trigger")
# @app.service_bus_queue_trigger(arg_name="msg", 
#                                queue_name="dpresservicebusqueue", 
#                                connection="")
# def test_function(msg: func.ServiceBusMessage):
#     logging.info('Python ServiceBus queue trigger processed message: %s',
#                  msg.get_body().decode('utf-8'))

import logging
import azure.functions as func

def main(msgIn: func.ServiceBusMessage):
    body = msgIn.get_body().decode('utf-8')
    logging.info(f'Processed Service Bus Queue message: {body}')