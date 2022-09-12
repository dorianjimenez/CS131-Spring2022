import asyncio
import aiohttp
import sys
import time
import json
import re
import logging

# Port Numbers: 12391 to 12395


class ServerMessage:

    # Holds all the client locations
    history = dict()

    # Hardcode Server Communications
    server_communications = {"Juzang": ["Clark", "Bernard", "Johnson"], "Bernard": ["Juzang", "Jaquez", "Johnson"], 
                             "Jaquez": ["Clark", "Bernard"], "Johnson": ["Juzang", "Bernard"], "Clark": ["Jaquez", "Juzang"]}

    # Names -> Ports 
    names_to_ports = {"Bernard": 12391, "Clark": 12392,  "Jaquez": 12393, "Johnson": 12394, "Juzang": 12395}


    def __init__(self, server_name):
        self.server_name = server_name

        # Config Logger
        logging.basicConfig(filename=(server_name + ".log"), encoding='utf-8', level=logging.INFO, filemode='w')


    def __call__(self, message):
        return self.parse_message(message) if len(message) else "ERROR: empty message"


    async def parse_message(self, message):

        

        # Log received message 
        logging.info("RECEIVED: " + message)
        
        # Parse Message
        try:
            parsed = message.split()
        except:
            return "? "

        # Check to make sure message is of correct length
        if len(parsed) <= 0:
            #print("1")
            return "? " + message

        # Handle IAMAT
        if(parsed[0] == "IAMAT"):

            # Check to make sure message is of correct length
            if len(parsed) != 4:
                #print("2")
                return "? " + message

            message = await self.handle_i_am_at(parsed[1], parsed[2], parsed[3], message)

            # Log sent message
            logging.info("SEND: " + message)

            return message

        # Handle WHATSAT
        elif (parsed[0] == "WHATSAT"):

            # Check to make sure message is of correct length
            if len(parsed) != 4:
                #print("3")
                return "? " + message

            message = await self.handle_whats_at(parsed[1], parsed[2], parsed[3], message)

            # Log sent message
            logging.info("SEND: " + message)

            return message

        elif (parsed[0] == "AT"):

            # Check to make sure message is of correct length
            if len(parsed) != 7:
                #print("4")
                return "? " + message

            if(parsed[6] != "poopiefartyfart"):
                return "? " + message

            message = await self.handle_at(message, parsed[5], parsed[3], parsed[6])

        # Handle Unrecognized Message
        else:
            #print("5")
            return "? " + message

        
    async def handle_at(self, message, new_timestamp, client_id, secret_key):

        # If incoming message has a client_id that is not in the dictionary, add it to the dictionary and propagate
        if(client_id not in self.history):
            self.history[client_id] = message.replace(' poopiefartyfart', '')
            await self.propagate(message)

        else:
            original_message = self.history[client_id].split()
            original_timestamp = original_message[5]

            # If incoming message is greater than one you have on file, update the dictionary and propagate
            if(original_timestamp < new_timestamp):
                self.history[client_id] = message.replace(' poopiefartyfart', '')
                await self.propagate(message)


    async def propagate(self, message):
        
        servers = self.server_communications[self.server_name]

        for i in range(len(servers)):
            try:
                reader, writer = await asyncio.open_connection('127.0.0.1', self.names_to_ports[servers[i]])
                writer.write(message.encode())
                await writer.drain()
                writer.close()


                logging.info("SEND TO " + servers[i] + ": " + message)

            except ConnectionRefusedError:

                logging.info("FAILED SEND TO " + servers[i] + ": " + message)
                continue


    async def handle_i_am_at(self, client_id, coordinates, timestamp, original_message):

        try:
            time_difference = time.time() - float(timestamp)
        except ValueError:
            return "? " + original_message

        time_difference = time.time() - float(timestamp)

        msg = ""
        if(time_difference < 0):
            msg = f"AT {self.server_name} {time.time() - float(timestamp)} {client_id} {coordinates} {timestamp}"
        else:
            msg = f"AT {self.server_name} +{time.time() - float(timestamp)} {client_id} {coordinates} {timestamp}"


        self.history[client_id] = msg

        await self.propagate(msg + " poopiefartyfart")

        return msg


    async def handle_whats_at(self, client_id, radius, max_results, message):

        # Check if radius is number
        try:
            radius_float = float(radius)
        except ValueError:
            return "? " + message

        # Check if max_results is a int
        try:
            max_results = int(max_results)
        except:
            #print("7")
            return "? " + message


        # If Client ID not found in the history
        if(client_id not in self.history):
            #print("6")
            return "? " + message
        

        # Get Google API data
        google_api_json = await self.get_google_data(client_id, self.history[client_id].split()[4], radius, max_results, message)
        
        
        # Check if max_results is greater than 20
        if(max_results > 20):
            #print("8")
            return "? " + message
        
        # Parse JSON 
        results = google_api_json['results'][:int(max_results)]
        google_api_json['results'] = results

        # Check Bad API Request
        if (google_api_json['status'] != "OK" and google_api_json['status'] != "ZERO_RESULTS"):
            #print("9")
            return "? " + message
        
        json_string = json.dumps(google_api_json, indent=3)

        # Get rid of trailing newlines, as well as more than two \n together
        json_string = json_string.rstrip()
        json_string = re.sub(r"\n{2,}", "\n", json_string)

        return self.history[client_id] + "\n" + json_string + "\n\n"
    

    async def get_google_data(self, client_id, unparsed_coordinates, radius, max_results, message):
        async with aiohttp.ClientSession() as session:

            # Parse Coordinates
            coordinates = ""
            if '-' in unparsed_coordinates[1:]:
                values = re.split('-', unparsed_coordinates[1:])

                first_coord = ""
                if(unparsed_coordinates[0] == '+'):
                    first_coord = values[0]
                elif(unparsed_coordinates[0] == '-'):
                    first_coord = '-' + values[0]
                else:
                    #print("10")
                    return "? " + message

                second_coord = '-' + values[1]
                coordinates = first_coord + ',' + second_coord

            elif '+' in unparsed_coordinates[1:]:
                values = re.split('\+', unparsed_coordinates[1:])

                first_coord = ""
                if(unparsed_coordinates[0] == '+'):
                    first_coord = values[0]
                elif(unparsed_coordinates[0] == '-'):
                    first_coord = '-' + values[0]
                else:
                    #print("11")
                    return "? " + message

                second_coord = values[1]
                coordinates = first_coord + ',' + second_coord

            else:
                #print("12")
                return "? " + message

            # Set Parameters
            params = [('location', coordinates), ('radius', (float(radius) * 1000.0)), ('key', MAPS_API_KEY)]
            
            async with session.get (MAPS_API_URL, params=params) as resp:
                return await resp.json()



async def main():
    # Error Checking: Check to see if 1 command-line argument is included
    if(len(sys.argv) != 2):
        exit(1)

    server_name = sys.argv[1]

    # Error Checking: Check to see if command-line argument is one of the server names
    if(server_name != "Juzang" and  server_name != "Bernard" and server_name != "Jaquez" and server_name != "Johnson" and server_name != "Clark"):
        exit(1)

    # Names -> Ports 
    names_to_ports = {"Bernard": 12391, "Clark": 12392,  "Jaquez": 12393, "Johnson": 12394, "Juzang": 12395}

    # Instantiate Class
    server_message = ServerMessage(sys.argv[1])

    # Start Server
    server = await asyncio.start_server(lambda r, w: handle_connection(r, w, server_message), host='127.0.0.1', port=names_to_ports[server_name])
    await server.serve_forever()

    
    
async def handle_connection(reader, writer, server_message):
    data = await reader.read()
    data = data.decode()
    message = await server_message.parse_message(data)

    if(message is not None):
        writer.write(message.encode())

    await writer.drain()
    writer.close()



if __name__ == '__main__':
    asyncio.run(main())
