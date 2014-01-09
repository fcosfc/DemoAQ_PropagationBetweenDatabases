/* ---------------------------------------------------------------------------
 * DemoAQEnqueuePropagationLOCAL.sql : enqueue some messages to be propagated.
 *
 * Author: Francisco Saucedo (http://fcosfc.wordpress.com)
 *
 * Versioning:
 *
 *    v1.0, 07-12-2011: Initial version.
 *
 * License: GNU GPL (http://www.gnu.org/licenses/gpl-3.0.html)
 * --------------------------------------------------------------------------- */
 
declare
  enq_msgid raw(16);
  eopt dbms_aq.enqueue_options_t;
  mprop dbms_aq.message_properties_t;
begin
  mprop.priority := 1;
  for i in 1..100
  loop
    dbms_aq.enqueue(queue_name => 'aqdemo_queue1', 
                    enqueue_options => eopt, 
                    message_properties => mprop, 
                    payload => test_type('This is a remote test message: ' || 
                                         lpad(i, 3, 0)), 
                    msgid => enq_msgid);
  end loop;
  commit;
end;