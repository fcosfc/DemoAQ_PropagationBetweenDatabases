/* ------------------------------------------------------------------------
 * CleanDemoAQPropagationREMOTE.sql : drop the objects created for the demo 
 *                                    DemoAQPropagationREMOTE.sql.
 *
 * Author: Francisco Saucedo (http://fcosfc.wordpress.com)
 *
 * Versioning:
 *
 *    v1.0, 07-12-2011: Initial version.
 *
 * License: GNU GPL (http://www.gnu.org/licenses/gpl-3.0.html)
 * ------------------------------------------------------------------------ */

drop procedure aqdemo_queue2_callback_p;
execute dbms_aqadm.stop_queue(queue_name => 'aqdemo_queue2');
execute dbms_aqadm.drop_queue(queue_name => 'aqdemo_queue2');
execute dbms_aqadm.drop_queue_table(queue_table => 'aqdemo_queue2_t');
drop table aqdemo_queue2_message_t;
drop type test_type;