# Copyright 2002-2011 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use
# this file except in compliance with the License. You may obtain a copy of the
# License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require "core/net"
require "core/nodex"
require "core/shared_data"

include Net

Nodex::go{
  conns = SharedData::get_set("conns")
  Server.new{ |socket|
    conns.add(socket.write_actor_id)
    socket.data_handler{ |data|
      conns.each{ |actor_id| Nodex::send_message(actor_id, data) }
    }
    socket.closed_handler{ conns.delete(socket.write_actor_id) }
  }.listen(8080)
}

puts "hit enter to exit"
STDIN.gets

