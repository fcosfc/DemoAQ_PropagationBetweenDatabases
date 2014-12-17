/* --------------------------------------------------------------------------------------------------------
 * DemoAQPropagationREMOTE.sql : setup the remote queue, which receive messages from the local queue, and a
 *                               notification procedure that dequeues each message and saves it in a table.
 *
 * Author: Francisco Saucedo (http://fcosfc.wordpress.com)
 *
 * Versioning:
 *
 *    v1.0, 07-12-2011: Initial version.
 *
 * License: GNU GPL (http://www.gnu.org/licenses/gpl-3.0.html)
 * -------------------------------------------------------------------------------------------------------- */
 
-- Create the type for the payload. It must have the same structure that the one created
--    in the other database. Be careful with the character sets of both databases.
create or replace type test_type as object (message CLOB);
/
begin
  -- Create a table for queues of the type defined before.
  dbms_aqadm.create_queue_table (queue_table => 'aqdemo_queue2_t', 
                                 queue_payload_type => 'TEST.TEST_TYPE', 
                                 multiple_consumers => true );
  -- Create the test queue, which will receive the messages from the queue on the LOCAL database.
  dbms_aqadm.create_queue (queue_name => 'aqdemo_queue2', 
                           queue_table => 'aqdemo_queue2_t');
  -- Start the queue for enqueuing and dequeuing messages.
  dbms_aqadm.start_queue (queue_name => 'aqdemo_queue2');
end;
/
-- Create a table to store the messages received.
create table aqdemo_queue2_message_t
  (received timestamp default systimestamp,
   message CLOB);
-- Create a callback procedure that dequeues the received message and saves it
create or replace
procedure aqdemo_queue2_callback_p
  (
    context raw,
    reginfo sys.aq$_reg_info,
    descr sys.aq$_descriptor,
    payload raw,
    payloadl number
  )
as
  r_dequeue_options dbms_aq.dequeue_options_t;
  r_message_properties dbms_aq.message_properties_t;
  v_message_handle raw(26);
  o_payload test_type;
begin
  r_dequeue_options.msgid         := descr.msg_id;
  r_dequeue_options.consumer_name := descr.consumer_name;
  dbms_aq.dequeue(queue_name => descr.queue_name, 
                  dequeue_options => r_dequeue_options, 
                  message_properties => r_message_properties, 
                  payload => o_payload, 
                  msgid => v_message_handle);
  insert into aqdemo_queue2_message_t 
    (message) 
    values (o_payload.message);
  commit;
exception
  when others then
    rollback;
end;
/
begin
  -- Register the procedure for dequeuing the messages received.
  -- I'd like to point out that the subscriber is the one defined for the local database
  dbms_aq.register (sys.aq$_reg_info_list(sys.aq$_reg_info('TEST.AQDEMO_QUEUE2:AQDEMO_QUEUE1_SUBSCRIBER', 
                                                           dbms_aq.namespace_aq, 'plsql://TEST.AQDEMO_QUEUE2_CALLBACK_P', 
                                                           hextoraw('FF'))), 
                    1);
end;
/
