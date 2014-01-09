/* -----------------------------------------------------------------------------------
 * DemoAQPropagationLOCAL.sql : setup the local queue, the messages send to this queue
 *                              will be propagated to the remote queue.
 *
 * Author: Francisco Saucedo (http://fcosfc.wordpress.com)
 *
 * Versioning:
 *
 *    v1.0, 07-12-2011: Initial version.
 *
 * License: GNU GPL (http://www.gnu.org/licenses/gpl-3.0.html)
 * ----------------------------------------------------------------------------------- */
 
-- Create the type for the payload. It must have the same structure that the one created
--    in the other database. Be careful with the character sets of both databases.
create or replace type test_type as object (message CLOB);
/
begin
  -- Create a table for queues of the type defined before.
  dbms_aqadm.create_queue_table (queue_table => 'aqdemo_queue1_t', 
                                 queue_payload_type => 'TEST.TEST_TYPE', 
                                 multiple_consumers => true);
  -- Create the test queue, which will receive the messages to be propagated.
  dbms_aqadm.create_queue (queue_name => 'aqdemo_queue1', 
                           queue_table => 'aqdemo_queue1_t');
  -- Start the queue for enqueuing and dequeuing messages.
  dbms_aqadm.start_queue (queue_name => 'aqdemo_queue1');
  -- Add the remote subscriber.
  dbms_aqadm.add_subscriber (queue_name => 'aqdemo_queue1', 
                             subscriber => sys.aq$_agent(name => 'aqdemo_queue1_subscriber', 
                                                         address => 'AQDEMO_QUEUE2@testaq', 
                                                         protocol => 0 ), 
                             queue_to_queue => true);
  -- Start the propagation of messages.
  dbms_aqadm.schedule_propagation(queue_name => 'TEST.AQDEMO_QUEUE1', 
                                  latency => 0, 
                                  destination => 'testaq', 
                                  destination_queue => 'TEST.AQDEMO_QUEUE2');
end;
/