/* -----------------------------------------------------------------------
 * CleanDemoAQPropagationLOCAL.sql : drop the objects created for the demo
 *                                   DemoAQPropagationLOCAL.sql.
 *
 * Author: Francisco Saucedo (http://fcosfc.wordpress.com)
 *
 * Versioning:
 *
 *    v1.0, 07-12-2011: Initial version.
 *
 * License: GNU GPL (http://www.gnu.org/licenses/gpl-3.0.html)
 * ----------------------------------------------------------------------- */
 
execute dbms_aqadm.stop_queue(queue_name => 'aqdemo_queue1');
execute dbms_aqadm.drop_queue(queue_name => 'aqdemo_queue1');
execute dbms_aqadm.drop_queue_table(queue_table => 'aqdemo_queue1_t');
drop type test_type;