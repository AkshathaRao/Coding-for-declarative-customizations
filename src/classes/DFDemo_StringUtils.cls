public class DFDemo_StringUtils {

    public static String[] splitByLines(String s) {
        if(String.isEmpty(s)) return new String[]{};

        return s.split('\n');
    }

    public static Map<String, String> getMapFromDelimitedString(String s, String outerDelimeter, String innerDelimeter, Set<String> keys) {
        Map<String, String> returnVar = new Map<String, String>();

        if(String.isEmpty(s) || String.isEmpty(outerDelimeter) || String.isEmpty(innerDelimeter) || keys.isEmpty()) {
            return returnVar;
        }

        List<String> outerVals = s.split(outerDelimeter);

        for(String outerVal :outerVals) {
            String key, value;
            List<String> innerVals = outerVal.split(innerDelimeter);
            if(innerVals.size() == 2) {
                key = innerVals[0];
                value = innerVals[1];

                if(keys.contains(key)) {
                    returnVar.put(key, value);
                }
            }
        }

        return returnVar;
    }

   public static String substitute(String templateString, String value){
        if (value == null)
           return substitute(templateString,(List<String>)null);
        else
           return substitute(templateString,new String[]{ value });
   }


   public static String substitute(String templateString, List<String> values){
        if (values != null && !values.isEmpty())
        {
            for (Integer i = 0; i < values.size(); i++)
            {
                templateString = templateString.replaceAll('\\{' + i + '\\}', values.get(i));
            }
        }
        return templateString;
   }

    public static String nullValue(String original, String replacement) {
        return (original==null) ? replacement : original;
    }

}