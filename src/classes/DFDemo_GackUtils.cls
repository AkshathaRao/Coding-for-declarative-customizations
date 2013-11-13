public with sharing class DFDemo_GackUtils {

    //Log debugging statements to syslog?
    private static final Boolean DO_DEBUG = true;

    //hook for testing Gack code
    private static Boolean TEST_GACK = false;
    private static List<String> debug_msgs = new List<String>();

    private static List<String> defaultEmailList = null;

    public static List<String> getDefaultExceptionEmailList() {
        if (defaultEmailList == null) {
           String emailListStr = System.Label.DFDemoDefault_Exception_Email_Address_List;
           if (emailListStr==null) {
               defaultEmailList = new List<String>(); //sendGack will correctly log issue if email List is empty
           }
           else {
               defaultEmailList = emailListStr.split(',');
           }
        }
        return defaultEmailList;
    }

    //Send Gack
    public static void sendGack (List<String> notifyEmail, String body, String Subject) {
        if (notifyEmail == null || notifyEmail.size()==0) {
            writeDebug('Could not email Gacks; no email addresses provided');
            writeDebug('Gack subject :' + subject);
            writeDebug('Gack body    :' + body);
        }
        else {
            writeDebug('notifyEmail :' + notifyEmail );
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(notifyEmail);
            mail.setSubject(Subject);
            mail.setPlainTextBody(body);
            Messaging.sendEmail(new Messaging.singleEmailMessage[] {mail});
        }
    }

    /* since this is all static, we need a way to keep gacks and emails on a per client basis
       since the per-module version already stored gacks in a 2-element array (subject, body)
       in the 0th element of a List of String arrays, we can store the emailIds in the next
       element of the of the list-of-arrays
     */
    public static List<String[]> initGacks(List<String> gackEmailIds) {
        List<String[]> gacks = new List<String[]>();
        gacks.add(new String[] {'', ''});
        gacks.add(gackEmailIds);
        return gacks;

    }

    /* convenience method - subject and body are often the same */
    public static void gack(List<String[]> gacks, String subject) {
        gack(gacks, subject, subject);
    }

    /* Creates a new gack */
    public static void gack(List<String[]> gacks, String subject, String body) {
        writeDebug('Adding GACKS:subject  -' + subject + ' - body-' +body);
        if(gacks.size()==0){
            gacks.add(new String[] {subject, body});
        }else{
            if (gacks.get(0).get(0)=='') {
                gacks.get(0)[0] = subject;
            }
            gacks.get(0)[1] += body + '\n';
        }
        if (gacks.get(0).get(1) != '' && gacks.get(0).get(1).length() > 30000 )
        {
            List<string> gackEmailIds = getGackEmailIds(gacks);
            sendGack(gackEmailIds, gacks.get(0).get(1), gacks.get(0).get(0) );
            gacks.get(0)[1]  = '';
        }

        writeDebug('Adding GACKS: -' + gacks);

    }

    //extract the emailIds (see initGacks for more)
    public static List<string> getGackEmailIds( List<string[]> gacks ) {
        if (gacks.size()<2) {
            return new List<String>();
        }
        return gacks.get(1);
    }

    /* Process gack messages that are queued */

    public static void processGacks( List<String[]> gacks ) {
        writeDebug('Processing GACKS');
        if(gacks.size() == 0) return;
        if (gacks.get(0).get(1) != '' ){
            writeDebug('gacks present');
            List<string> gackEmailIds = getGackEmailIds(gacks);
            sendGack(gackEmailIds, gacks.get(0).get(1), gacks.get(0).get(0) );
        }
    }


     /* Wrapper for System.debug call */
    private static void writeDebug(String msg){
        if(DO_DEBUG){
           System.debug('***  GACK DEBUG ***: '+msg);
        }
        if(TEST_GACK){
            debug_msgs.add(msg);
        }
    }
 }